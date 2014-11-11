class Project < ActiveRecord::Base
  belongs_to :account
  belongs_to :folder
  has_one  :videopage

  has_many :assets
  has_many :video_access_tokens

  has_many :cta_optins,    class_name: "CtaOptin",    foreign_key: "project_id"
  has_many :cta_buttons,   class_name: "CtaButton",   foreign_key: "project_id"
  has_many :cta_htmls,     class_name: "CtaHtml",     foreign_key: "project_id"
  has_many :cta_surveys,   class_name: "CtaSurvey",   foreign_key: "project_id"
  has_many :cta_purchases, class_name: "CtaPurchase", foreign_key: "project_id"
  has_many :cta_tags,      class_name: "CtaTag",      foreign_key: "project_id"

  acts_as_list scope: :folder

  attr_accessible :allowed_urls, :analytics, :tags, :title, :license_key, :folder_id, :favorite, :responder_code, :asset_ids

  hstore_accessor :flowplayer, %i(auto_start skin skin_color embed_code show_banner affiliate_link
                                  url extension dimensions max_width max_height custom_width custom_height logo logo_pos_left 
                                  logo_pos_right scaling start_image control_bar_hide_method cb_gap duration align csn_id)

  hstore_accessor :flowplayer, %i(big_play_button allow_pause loop display_time display_volume play_button
                                  allow_embed full_screen display_time_percentage display_buffer auto_mute mute
                                  email_share google_share twitter_share show_banner facebook_share), :boolean
  validates :cid, uniqueness: true, presence: true
  validates :skin_color, rgb: true

  before_validation do
    self.cid ||= SecureRandom.hex(16)
  end

  after_create do
    unless self.folder.present?
      self.folder = self.account.folders.first
    end
    self.save
    self.insert_at(folder.projects.where { favorite == true }.count + 1)
  end

  def folder_id=(folder_id)
    if self[:folder_id] != folder_id
      self.remove_from_list
      self[:folder_id] = folder_id
    end
  end

  def date
    I18n.l(created_at, format: '%d %b %Y')
  end

  # TODO because of "multiple source of truth" problem in js
  # i decided to write this monley patch. It should be rewritten
  # as regular field in the future.
  def filename
    if url
      url.match(%r{([^\/]+\z)})[0]
    else
      nil
    end
  end

  def all_ctas
    Cta.where(project_id: id)
  end

  def ctas(session=nil)
    {
      buttons:   cta_buttons.order("id ASC").as_json,
      htmls:     cta_htmls.order("id ASC").as_json,
      
      surveys:   (session.present? ? cta_surveys.unique_for_session(session) : cta_surveys).order("id ASC").uniq.as_json,

      optins:    cta_optins.order("id ASC").as_json,
      purchases: cta_purchases.order("id ASC").as_json,
      tags:      cta_tags.order("id ASC").as_json
    }
  end

  def as_json(options={})
    super(
      options.merge(
        only:     [:id, :cid, :title, :folder_id, :tags, :allowed_urls, :position, :favorite, :responder_code, :dashboard, :analytics],
        methods:  [:date, :filename],
        include:  [:assets]
      )
    ).merge(self.flowplayer)
  end

  def to_param
    cid
  end

  def create_cta(attrs)
    if Module.const_get(attrs[:type]) && Cta.subclasses.map(&:to_s).include?(attrs[:type])
      eval(attrs[:type].pluralize.underscore).create!(attrs)
    end
  end

  def allow_play?
    cta_purchases.has_delivery_method("play_video").empty?
  end

  def allowed_token?(token)
    video_access_tokens.where(token: token).present?
  end

  def paste_in_right_place
    # in case of more stability
    Rails.logger.warn "### Project Moving >> paste in right place"
    #Project.transaction do
      reload
      folder.reload

      ts = folder.two_stars_projects_count
      # od = folder.only_dashboard_projects_count
      of = folder.only_favorite_projects_count
    
      right_position = if favorite and dashboard
                         1
                       elsif !favorite and dashboard
                         ts+1
                       elsif favorite and !dashboard
                         # ts+od+1
                         ts+1
                       else
                         ts+of+1
                         # ts+od+of+1
                       end 

      insert_at right_position
    #end
    self
  end

  def toggle_favorite
    toggle :favorite
    save!
    paste_in_right_place
    self
  end

  def toggle_dashboard
    if dashboard
      self.dashboard = false
    else
      self.dashboard = true
    end
    
    save!
    paste_in_right_place
    self
  end

  def cdn_url(referer)
    ref_uri = URI(referer)
    host = ref_uri.host.split(".").last(2).join(".")
    key = FlowplayerLicense.new(host).key
    url = "#{Yetting.cloudfront_host}/embeds/#{account_id}/#{cid}#{updated_at.to_i}#{key}.js"

    uri = URI("http:#{url}")
    request = Net::HTTP.new uri.host
    response = request.request_head uri.path

    if response.code.to_i == 200
      url
    else
      account.update_attribute(:logged_sites, account.logged_sites.split(",").push(host).join(",")) unless account.logged_sites.index(host)
      url
    end
  end

  def short_cid
    self.cid.first(4)
  end

  def width
    dimensions.split("x").first.to_f
  end

  def height
    dimensions.split("x").last.to_f
  end

end
