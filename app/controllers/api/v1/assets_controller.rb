module Api
  module V1
    class AssetsController < Api::V1::BaseController
      inherit_resources
      include UploadsHelper
      before_filter :authenticate_user!

      respond_to :json

      def rackspace_url
        csn_id   = params[:csn_id]
        storage  = current_user.account.csns.find(csn_id)

        respond_with({
                         url: Asset.generate_rackspace_url(params[:type] || 'streaming', params[:filename], storage)
                     })
      end

      def upload_form_params
        filename = params[:filename]
        csn_id   = params[:csn_id]
        storage  = Integration.find(csn_id)
        path = storage.is_company_csn ? "#{current_user.security_salt}" : false
        respond_with generate_upload_form_params(storage, filename, path)
      end

      def show
        @asset = Asset.find(params[:id])
        respond_with(@asset)
      end

      def start_encoding
        @asset = current_user.assets.find(params[:id])
        panda_video = Panda::Video.find(@asset.video_id)

        if panda_video.encodings == nil
          status = 'Prepare for encoding'
        else
          status = 'Encoding'
          @asset.encoding_job_id = panda_video.encodings.first.id
          @asset.save

          current_user.account.increment!(:number_of_jobs)
        end

        render json: {video: panda_video, status: status}
      end

      def info_encoding
        @asset = current_user.assets.find(params[:id])
        encoding_status = Panda::Encoding.find(@asset.encoding_job_id)

        if encoding_status.status == 'success'
          new_name = @asset.original_filename.split(".").first + encoding_status.extname
          @asset.update_attributes(needs_encoding: false,
                                   remote_url: encoding_status.url,
                                   encoded_filename: encoding_status.files.first,
                                   result_filename: new_name)

          [0, 1, 2, 3, 4].each do |n|
            eval("@asset.thumbnail#{n} = encoding_status.screenshots[#{n}]")
          end
          @asset.save
          copy_from_encoded_bucket
        end

        render json: {info: encoding_status}
      end

      def is_finished
        @asset = current_user.assets.find(params[:id])
        result = @asset.file_accessible?

        if result
          @asset.update_attribute :unavailable, (not result)
        end

        render json: { finished: result, remote_url: @asset.remote_url }
      end

      def copy_from_encoded_bucket
        @asset = current_user.assets.find(params[:id])

        if !@asset.needs_encoding
          @asset.copy_from_encoded_bucket('opencoding', @asset.encoded_filename, "ophosting/#{current_user.security_salt}", @asset.result_filename)
        end
      end

      def create
        @asset = current_user.assets.new(params[:asset])
        if @asset.save
          if @asset.needs_encoding
            authorize! :encode, @asset
            @asset.prepare_attachment
          end
          respond_to do |format|
            format.json { render json: @asset }
          end
        end
      end

      def destroy
        @asset = current_user.assets.find(params[:id])
        @asset.destroy
        respond_to do |format|
          format.html { redirect_to my_uploads_path }
          format.json { head :no_content }
        end
      end
    end
  end
end
