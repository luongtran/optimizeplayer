class Cta < ActiveRecord::Base
  attr_accessible :html, :project_id, :type
  belongs_to :project

  hstore_accessor :options, %i(background_color font_family font_style font_size text_color location cuepoints position 
                               text link overlay background_opacity text_opacity left top right bottom  width height
                               left_background_color left_background_color_opacity right_background_color right_background_color_opacity 
                               fullscreen_left fullscreen_top)

  hstore_accessor :options, %i(on_start on_pause on_finish on_cuepoints fullscreen smart_optin skip preview), :bool

  validates :background_color, :text_color, rgb: true

  def as_json(options={})
    {
      cuepoints: cuepoints ? JSON.parse(cuepoints) : [],
      id: id,
      cid: id,
      type: type,
      html: html
    }.merge(self.options.except("cuepoints"))
  end

  def formatted_type
    type.scan(/[A-Z][^A-Z]*/)[1..-1].join("_").downcase
  end

end