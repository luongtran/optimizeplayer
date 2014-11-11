module Api
  module V2
    class SurveyOptionsController < Api::V2::BaseController

      def create
        options = SurveyOption.find(params[:option_ids])

        options.each do |option|
          SurveyOption.transaction do
            option.answers[params[:session_key]] = "true"
            option.survey_question.answers[params[:session_key]] = "true"
            option.survey_question.save!
            option.save!
          end
        end

        render nothing: true, status: :ok
      end
      
    end
  end
end