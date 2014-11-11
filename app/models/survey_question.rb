class SurveyQuestion < ActiveRecord::Base
  serialize :answers, ActiveRecord::Coders::Hstore
  
  attr_accessible :cta_survey_id, :text, :survey_options_attributes

  belongs_to :cta_survey
  has_many :survey_options, dependent: :destroy

  validates :text, presence: true

  accepts_nested_attributes_for :survey_options, allow_destroy: true

  before_save { survey_options_attributes ||= [] }

  def as_json(options={})
    {
      id: id,
      text: text,
      survey_options_attributes: survey_options.order("id ASC").as_json
    }
  end
end
