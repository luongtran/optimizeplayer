class CtaSurvey < Cta
  attr_accessible :survey_questions_attributes
  
  hstore_accessor :options, %i(header_text button_text header_color button_color answers_bg_color text_opacity button_bg_color
                               button_bg_color_opacity answers_bg_color_opacity header_color_opacity)

  has_many :survey_questions, dependent: :destroy

  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  validates :header_color, :button_bg_color, :answers_bg_color, :text_color, rgb: true

  scope :unique_for_session, lambda { |session| 
    joins(:survey_questions).where("survey_questions.answers IS NULL OR NOT(survey_questions.answers ? '#{session}')")
  }

  def as_json(options={})
    super.merge(survey_questions_attributes: survey_questions.order("id ASC").as_json)
  end

end
