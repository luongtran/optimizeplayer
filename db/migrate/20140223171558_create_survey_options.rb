class CreateSurveyOptions < ActiveRecord::Migration
  def change
    create_table :survey_options do |t|
      t.integer :cta_survey_id
      t.string :text
      t.hstore :answers

      t.timestamps
    end

    add_index :survey_options, :cta_survey_id
  end
end
