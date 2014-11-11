class Asset < ActiveRecord::Base
  attr_accessible :original_filename, :user_id, :user, :project_id, :video_id,
                  :file_origin, :media_type, :keep_video_size, :remote_url, :original_bucket,
                  :encoding_job_id, :needs_encoding, :csn_id, :key, :download_url, :unavailable,
                  :rand_id, :encoded_filename, :result_filename

hstore_accessor :thumbnails, %i(thumbnail0 thumbnail1 thumbnail2 thumbnail3 thumbnail4)

  belongs_to :user
  belongs_to :project
  belongs_to :csn, :class_name => 'Integration'

  before_create do
    self.rand_id = rand(1000)
  end

  def self.generate_rackspace_url(type, filename, storage)
    case type
      when 'streaming'
        "#{storage.rs_streaming_url}/#{filename}"
      when 'public'
        "#{storage.rs_public_url}/#{filename}"
    end
  end

  def prepare_attachment
    raise 'Cannot Asset#prepare_attachment with empty download_url' unless download_url?
    self.unavailable = true

    panda_video = Panda::Video.create!(source_url: download_url)
    update_attributes(video_id: panda_video.id)
  end

  def file_accessible?
    url = URI.parse URI.encode(http_url)
    resp_head = nil
    Net::HTTP.start(url.host, 80) do |http|
      resp_head = http.head(url.path)
    end

    p http_url

    return (resp_head.code.to_i == 200)
  end

  def avoid_filename_confilcts
    return unless unavailable
    while file_accessible?
      self.rand_id = rand(1000)
    end
  end

  def stored_filename
    "op-#{self.original_filename.split('.')[0].gsub(/[\[\]\{\} ]/, "_")}-#{rand_id}.mp4"
  end

  def s3_directive
    "s3://#{csn.access_key_id}:#{csn.secret_access_key}@#{csn.storage_service.bucket_key}/uploads/#{stored_filename}"
  end

  def cf_directive
    "cf://#{csn.access_key_id}:#{csn.secret_access_key}@#{csn.storage_service.bucket_key}/#{stored_filename}"
  end

  def s3_url
    "https://s3.amazonaws.com/#{csn.storage_service.bucket_key}/uploads/#{stored_filename}"
  end

  def s3_user_encodings_url
    "https://s3.amazonaws.com/#{csn.bucket}/#{user.security_salt}/encodings/#{result_filename.split('.')[0].gsub(/[\[\]\{\} ]/, "_")}-#{rand_id}.mp4"
  end

  def cf_url
    "#{csn.rs_streaming_url}/#{stored_filename}"
  end

  # normal, not streaming url for downloading and availability checking
  def http_url
    if csn.provider == 'rackspace'
      "#{csn.rs_public_url}/#{stored_filename}"
    else
      # csn.integration_type == 'company_csn' ? s3_user_encodings_url : s3_url
      s3_user_encodings_url
    end
  end

  def copy_to_main_bucket
    return if (original_bucket == csn.bucket) and (csn.provider == 'rackspace')

    self.unavailable = true
    avoid_filename_confilcts
    self.unavailable = false

    csn.storage_service.copy_to_main_bucket(original_bucket, original_filename, stored_filename)

    prefix = (csn.provider == 'rackspace' ? 'cf' : 's3')
    self.remote_url = send "#{prefix}_url"
    save
  end

  def copy_from_encoded_bucket(bucket, filename, tearget_bucket, new_filename)
    csn.storage_service.copy_from_encoded_bucket(bucket, filename, tearget_bucket, "#{result_filename.split('.')[0].gsub(/[\[\]\{\} ]/, "_")}-#{rand_id}.mp4")

    self.remote_url = s3_user_encodings_url
    save
  end

  def as_json(options={})
    super options.merge(
      only:     [:id, :file_origin, :download_job_id, :remote_url, :download_url, :original_bucket, :original_filename, :content_type, :keep_video_size, :csn_id, :needs_encoding, :unavailable],
      methods:  [:url]
    )
  end

end
