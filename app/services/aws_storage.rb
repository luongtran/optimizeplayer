class AwsStorage < StorageService

  attr_accessor :credentials

  def initialize(csn)
    @csn         = csn
    @credentials = { provider: 'AWS', aws_access_key_id: @csn.access_key_id, aws_secret_access_key: @csn.secret_access_key }
    @connection  = Fog::Storage.new(@credentials)
    @bucket      = find_or_create_bucket!
  end

  def create_distribution
    cdn = Fog::CDN.new(@credentials)
    distribution = cdn.distributions.select { |dist| !dist.s3_origin.nil? && dist.s3_origin['DNSName'] == "#{bucket_key}.s3.amazonaws.com" }.first
    if distribution.blank?
      distribution = cdn.distributions.create(:s3_origin => {
        'DNSName' => "#{bucket_key}.s3.amazonaws.com",
        'OriginProtocolPolicy' => 'match-viewer'
      }, :enabled => true)
    end

    unless @csn.cloudfront == distribution.domain
      @csn.update_attribute(:cloudfront, distribution.domain)
    end

    rescue Excon::Errors::BadRequest => e
      create_distribution
  end

  def apply_cors_rules
    prefix = if Rails.env == 'development'
               'http://*.'
             else
               'https://*.'
             end
    cors = {
      'CORSConfiguration' => [
        {
          'AllowedOrigin' => "#{prefix}#{ActionMailer::Base.default_url_options[:host]}",
          'AllowedMethod' => ['POST', 'GET', 'PUT'],
          'AllowedHeader' => '*',
          'MaxAgeSeconds' => 3000
        }
      ]
    }
    @connection.put_bucket_cors(bucket_key, cors)
  end

  def return_tree(root, node)
    node.map do |path, subtree|
      if obj = root.files.map { |f| f if f.key == path.include?('.') ? path.sub(/^\//, '') : (path.gsub('/', '') + '/') }.first
        {
                url: 'https://s3.amazonaws.com/' + root.key + path.gsub(' ', '+'),
                key: root.key + path.gsub(' ', '+'),
               name: File.basename(path),
               size: number_to_human_size(obj.content_length),
           modified: obj.last_modified.strftime('%D'),
           children: return_tree(root, subtree),
          extension: path.include?('.') ? path.split('.')[1] : '',
       content_type: MIME::Types.type_for(path)[0].try(:content_type)
        }
      end
    end
  end

  def get_bucket_tree(bucket_name)
    result    = {
      subdirs:  {},
      files:    []
    }
    content   = @connection.get_bucket(bucket_name)[:body]["Contents"] # its array of hashes

    dirs = content.select{ |e| e["Key"] =~ /\/\z/}
    files = content - dirs

    # populate with files
    files.each do |file|
      path, filename = nil, nil
      file["Key"].split('/').tap do |splitted|
        path, filename = splitted[0..-2], splitted[-1]
      end

      point_to_insert = path.inject(result) do |current, dir|
        unless current[:subdirs][dir]
          current[:subdirs][dir] = {
            subdirs:  {},
            files:    []
          }
        end
        current[:subdirs][dir]
      end[:files]

      point_to_insert << {
        url: 'https://s3.amazonaws.com/' + bucket_name + '/' + file["Key"].gsub(' ', '+'),
        download_url: 'https://s3.amazonaws.com/' + bucket_name + '/' + file["Key"].gsub(' ', '+'),
        bucket: bucket_name,
        file_key: file["Key"].gsub(' ', '+'),
        name: filename,
        size: number_to_human_size(file["Size"]),
        extension: filename.include?('.') ? filename.split('.')[-1] : '',
        content_type: MIME::Types.type_for(filename)[0].try(:content_type)
      }
    end

    tree = ->(folder) do
      children = []
      folder.each do |k, v|
        children.push({name: k, files: v[:files], subdirs: v[:subdirs].present? ? tree.call(v[:subdirs]) : []})
      end
      children
    end

    {
      subdirs: tree.(result[:subdirs]),
      files: result[:files]
    }
  end

  def copy_to_main_bucket(bucket, filename, new_filename)
    @connection.copy_object(bucket, filename, bucket_key, "uploads/#{new_filename}")
    @connection.put_object_acl(bucket_key, "uploads/#{new_filename}", 'public-read')
  end

  def copy_from_encoded_bucket(bucket, filename, target_backet, new_filename)
    @connection.copy_object(bucket, filename, target_backet, "encodings/#{new_filename}")
    @connection.put_object_acl(target_backet, "encodings/#{new_filename}", 'public-read')
  end

end
