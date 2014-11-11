class FlowplayerLicense
  attr_reader :key

  def initialize(host = "")
    @key = Digest::MD5.hexdigest("#{host}d394c3b835a6271c75f")[11..29]
  end

end