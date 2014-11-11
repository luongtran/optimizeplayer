class StorageService
  include ActionView::Helpers::NumberHelper
  attr_reader :bucket, :connection

  def get_bucket
    @connection.directories.get(bucket_key)
  end

  def find_or_create_bucket!
    get_bucket.nil? ? @connection.directories.create(key: bucket_key, public: true) : get_bucket
  end

  def get_buckets_list
    @connection.directories.map { |d| {name: d.key} }.select { |d| d[:name] != '.CDN_ACCESS_LOGS' }
  end

  # must be overridden
  def apply_cors_rules(bucket)
  end

  # must be overridden
  def get_bucket_tree(bucket_name)
  end

  def bucket_key
    @csn.bucket
  end

  # must be overridden
  def copy_to_main_bucket(bucket, filename, new_filename)
  end

  def objects(bucket)
    objects = bucket.files
    tree    = {}

    objects.map(&:key).each do |path|
      current  = tree
      path.split("/").inject("") do |sub_path, dir|
        sub_path = File.join(sub_path, dir)
        current[sub_path] ||= {}
        current = current[sub_path]
        sub_path
      end
    end
    return_tree(bucket, tree)
  end

end
