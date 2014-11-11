if Rails.env.test?
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :webmock 
  end
  VCR.use_cassette('heywatch') do
    HEYWATCH = HeyWatch.new("pixelserve", "applej44")
  end
else
  HEYWATCH = HeyWatch.new("pixelserve", "applej44")
end
