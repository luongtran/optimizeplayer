class AddSurveyQuestionIdToSurveyOption < ActiveRecord::Migration
  def change
    add_column :survey_options, :survey_question_id, :integer
  end
end
