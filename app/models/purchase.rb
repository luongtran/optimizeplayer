class Purchase < ActiveRecord::Base
  serialize :payment_info, ActiveRecord::Coders::Hstore

  attr_accessible :cta_id, :payment_info

  belongs_to :cta_purchase
  belongs_to :video_access_token
  delegate :project, to: :cta_purchase
  delegate :delivery_method, to: :cta_purchase
  after_save :deliver, if: Proc.new { |purchase| ['SALE', 'DECLINE'].include?(purchase.state) }

  def fullname
    payment_info['fullname'].present? ? payment_info['fullname'] : [payment_info['first_name'], payment_info['last_name']].join(' ')
  end

  def deliver
    if state == 'SALE' && delivery_method == 'play_video'
      token = project.video_access_tokens.create!
      update_column(:video_access_token_id, token.id)
      PurchasesMailer.delay.video_access_token(payment_info['email'], token, payment_info['referer'])
    end
    IpnNotifierWorker.perform_async(id) if cta_purchase.ipn_url.present?
  end
end
