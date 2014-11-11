class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.integer :cta_survey_id
      t.string :text

      t.timestamps
    end
  end
end
