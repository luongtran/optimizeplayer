module Api
  module V1
    class VideopagesController < Api::V1::BaseController
      respond_to :json
      inherit_resources
      before_filter :find_project, :only => [:page, :save, :slug_save]

      def page
        respond_with @videopage
      end

      def save
        unless params[:data][:widgets].blank?
          params[:data][:widgets].each do |widget|

            if !widget[:customHtml].blank?
              widget[:customHtml] = nice_html widget[:customHtml]
            elsif !widget[:text].blank?
              widget[:text] = nice_html widget[:text]
            end
          end
        end

        unless params[:data][:slug].blank? and params[:data][:slug][:slug].blank?
          slug = CGI::escapeHTML(params[:data][:slug][:slug])
        end

        current_user ? uid = current_user.id : uid = nil
        # , :url => params[:data][:url]
        @videopage.update_attributes :widgets => params[:data][:widgets].to_json,  :template => params[:data][:template], :seo => params[:data][:seo].to_json, :settings => params[:data][:settings], :slug => slug, :user_id => uid
        respond_with 'ok'
      end

      def slug_save
        unless params[:slug].blank? and params[:slug][:slug].blank?
          params[:slug][:slug] = CGI::escapeHTML(params[:slug][:slug])
          # :url => params[:slug],
          @videopage.update_attributes(:slug => params[:slug][:slug])
          respond_with 'ok'
        else
          respond_with 'error'
        end
      end
      protected

      def find_project
        @videopage = Videopage.find_by_project_id params[:id]
      end

      #TODO will need to return back to savemode without XSS
      def nice_html(html_code)
        html_code
        # tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
        # ActionController::Base.helpers.sanitize(html_code, tags: tags, attributes: %w(href title))
      end

    end
  end
end