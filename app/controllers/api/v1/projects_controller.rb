module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      respond_to :json
      inherit_resources
      custom_actions resource: [:set_position, :toggle_favorite]
      custom_actions collection: [:move]

      def set_position
        if params[:position]
          resource.set_list_position(params[:position].to_i)
        end
        respond_with resource
      end

      def toggle_favorite
        resource.toggle_favorite
        respond_with resource
      end

      def move
        ids = params[:ids]
        source_folder = Project.find(params[:ids].first).folder
        folder_id = params[:folder_id]
        dest_folder = Folder.find(folder_id)
        Project.where(id: ids).each do |project|
          if project.folder_id.to_i != folder_id.to_i
            project.reload
            project.folder_id = folder_id
            project.save!
            project.paste_in_right_place
          end
        end

        respond_with 'ok'
      end

      protected

      def find_project
        @project = Project.find params[:id]
      end

      def begin_of_association_chain
        current_account
      end

      def collection
        unless @projects
          @projects = end_of_association_chain
          if params[:folder_id]
            @projects = @projects.where(folder_id: params[:folder_id])
          end
          if params[:search]
            s = "%#{params[:search]}%"
            rexp = /\/([0-9a-z]+)'/
            puts(request.base_url)
            embed_exp = /<script src=\'#{request.base_url}\/projects\/([0-9a-z]+)\.js\'><\/script>/
            if s =~ embed_exp
              @projects = @projects.where{cid == s.match(embed_exp)[1]}
            elsif s =~ rexp
              @projects = @projects.where{(title =~ s) | (tags =~ s) | (cid =~ s) | (cid =~ s.match(rexp)[1])}
            else
              @projects = @projects.where{(title =~ s) | (tags =~ s) | (cid =~ s)}
            end
          end
          if params[:recent]
            @projects = @projects.order{updated_at.desc}.limit(5)
          end
          if params[:newest]
            @projects = @projects.order{created_at.desc}.limit(5)
          end

          @projects = @projects.order(:position) unless params[:recent] or params[:newest]
        end
        @projects
      end
    end
  end
end
