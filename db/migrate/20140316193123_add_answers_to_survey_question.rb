class AddAnswersToSurveyQuestion < ActiveRecord::Migration
  def change
    add_column :survey_questions, :answers, :hstore
  end
end
