class SurveyOption < ActiveRecord::Base
  serialize :answers, ActiveRecord::Coders::Hstore

  attr_accessible :text, :answers, :cta_survey_id, :answers_count
  attr_accessor :answers_count

  belongs_to :cta_survey
  belongs_to :survey_question

  validates :text, presence: true

  def as_json(options={})
    {
      id: id,
      text: text,
      answers_count: answers.size
    }
  end
end
