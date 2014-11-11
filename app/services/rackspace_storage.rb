class RackspaceStorage  < StorageService

  def initialize(csn)
    @csn = csn
    @connection = Fog::Storage.new(
      :provider                 => 'Rackspace',
      :rackspace_username       => csn.username,
      :rackspace_api_key        => csn.api_key
    )
    @bucket = find_or_create_bucket!
  end

  def directories_tree
    @connection.directories.select {|d| d.public? }.map do |bucket|
      { name: bucket.key, children: objects(bucket) }
    end
  end
  
  def get_bucket_tree(bucket_name)
    bucket   = @connection.directories.get(bucket_name)
    base_url = bucket.streaming_url
    http_url = bucket.public_url
    files    = bucket.files

    {
      subdirs: [],
      files: files.map do |file|
        {
          url: base_url + '/' + file.key,
          download_url: http_url + '/' + file.key,
          name: file.key,
          size: number_to_human_size(file.content_length),
          extension: file.key.include?('.') ? file.key.split('.')[-1] : '',
          content_type: file.content_type
        }
      end
    }
  end

  def apply_cors_rules
    bucket = get_bucket
    bucket.metadata = bucket.metadata.merge({
      # 'Access-Control-Allow-Origin' => "http://*.#{ActionMailer::Base.default_url_options[:host]}",
      'Access-Control-Allow-Origin' => "*",
      'Access-Control-Max-Age' => 1000
    })
    bucket.save
  end

  def return_tree(root, node)
    host = root.public_url
    node.map do |path, subtree|
      if obj = root.files.select { |f| f.key == (path.include?('.') ? path.sub(/^\//, '') : (path.gsub('/', '') + '/')) }.first
        {
                url: "#{host}/#{path.gsub(' ', '+')}",
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

  def copy_to_main_bucket(bucket, filename, new_filename)
    @connection.copy_object(bucket, filename, bucket_key, new_filename)
  end
end
