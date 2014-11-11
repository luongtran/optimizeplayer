module UploadsHelper
  def generate_upload_form_params(storage, filename, path)
    if storage.provider == 'rackspace'
      return generate_rackspace_form_params(
        storage.rs_temp_url_key,
        storage.bucket,
        storage.rs_endpoint_url,
        storage.rs_endpoint_path
      )
    else # aws
      return generate_s3_form_params(storage.access_key_id, storage.secret_access_key, storage.bucket, filename, path)
    end
  end

  def generate_s3_form_params(access_key, secret_key, bucket, filename, path = false)
    directory = path ? "#{path}/uploads" : 'uploads'
    starts_with = path ? "#{path}" : 'uploads'

    key                    = "#{directory}/${filename}"
    content_type           = MIME::Types.type_for(filename).first.content_type
    success_action_status  = "201"
    acl                    = 'public-read'
    expiration_date        = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize           = 4096.megabytes

    policy_data = {
      expiration: expiration_date,
      conditions: [
        #["starts-with", "$utf8", ""],
        ["starts-with", "$key", "#{starts_with}/"],
        ["starts-with", "$x-requested-with", ""],
        ["content-length-range", 0, max_filesize],
        ["starts-with","$Content-Type", ""],
        {bucket: bucket},
        {acl: acl},
        {success_action_status: success_action_status}
      ]
    }

    policy = Base64.encode64(policy_data.to_json.gsub("\n", "")).gsub("\n", "")
    signature = Base64.encode64(
                  OpenSSL::HMAC.digest(
                    OpenSSL::Digest::Digest.new('sha1'),
                    secret_key, policy
                  )
                ).gsub("\n", "")

    hidden_inputs = {
      'key' => key,
      'acl' => acl,
      "AWSAccessKeyId" => access_key,
      'policy' => policy,
      'signature' => signature,
      'success_action_status' => success_action_status,
      'Content-Type' => content_type,
      'X-Requested-With' => 'xhr'
    }

    return { action: "https://#{bucket}.s3.amazonaws.com/", hidden_inputs: hidden_inputs }
  end


  def generate_rackspace_form_params(secret_key, bucket, action_url, action_path)
    action          = "#{action_url}/#{bucket}/op-"
    path            = "#{action_path}/#{bucket}/op-"
    max_file_count  = 1
    max_file_size   = 4096.megabytes
    expires         = (Time.now.to_i + 600).to_s

    signature_raw = sprintf("%s\n%s\n%s\n%s\n%s", path, '', max_file_size, max_file_count, expires)
    signature     = OpenSSL::HMAC.hexdigest('sha1', secret_key, signature_raw)

    hidden_inputs = {
      'max_file_size'   => max_file_size,
      'max_file_count'  => max_file_count,
      'expires'         => expires,
      'signature'       => signature
    }
    return { action: action, hidden_inputs: hidden_inputs }
  end
end
