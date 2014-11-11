class CtaOptin < Cta
  attr_accessible :integration_id
  
  hstore_accessor :options, %i(list_id button_background_color button_background_opacity header_text)
  belongs_to :integration

  validates :button_background_color, :text_color, rgb: true

  def as_json(options={})
    super.merge({
                  integration_id: integration_id,
                  provider: Integration.find(integration_id).provider
                })
  end
end
