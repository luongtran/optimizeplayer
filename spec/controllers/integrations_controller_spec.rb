require 'cgi'
describe Api::V1::IntegrationsController do

  let(:user) { FactoryGirl.create(:user)}
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    @request.host = "#{user.url}.stage.lvh.me"
  end

  context '#mailchimp' do
    it "should be successful to get mailchimp lists" do
      integration = FactoryGirl.create :integration_mailchimp
      VCR.use_cassette('mailchimp') do
        get :mailchimp_lists, { :id => integration.id }
      end
      response.status.should eql 200
    end
  end

  context '#aweber' do
    it "should be successful to get aweber lists" do
      integration = FactoryGirl.create :integration_aweber

      query_matcher = lambda do |request1, request2|
        query1 = URI.parse(request1.uri).query
        query2 = URI.parse(request2.uri).query
        params1 = CGI.parse(query1)
        params2 = CGI.parse(query2)
        params1['oauth_consumer_key'].first == params2['oauth_consumer_key'].first && params1['oauth_token'].first == params2['oauth_token'].first
      end

      VCR.use_cassette('aweber', :match_requests_on => [:method, :host, :path, query_matcher]) do
        get :aweber_lists, {:id => integration.id}
      end
      response.status.should eql 200
    end
  end

  context '#getresponse' do
    it "should be successful to get getresponse campaigns" do
      integration = FactoryGirl.create :integration_getresponse
      VCR.use_cassette('getresponse') do
        get :getresponse_campaigns, {:id => integration.id}
      end
      response.status.should eql 200
    end
  end

  context '#amazons3' do
    it "should be successful to get amazon s3 directories" do
      VCR.use_cassette('amazons3_1') do
        integration = FactoryGirl.create :integration_amazons3
        get :csn_directories, {:id => integration.id, :provider => integration.provider}
      end
      response.status.should eql 200
    end

    it "should be successful to get all the directories under the specific amazon s3 bucket" do
      VCR.use_cassette('amazons3_2') do
        integration = FactoryGirl.create :integration_amazons3
        get :csn_directories, {:id => integration.id, :provider => integration.provider, :bucket => integration.bucket}
      end
      response.status.should eql 200
    end
  end

  context '#rackspace' do
    it "should be successful to get rackspace directories" do
      VCR.use_cassette('rackspace_1') do
        integration = FactoryGirl.create :integration_amazons3
        get :csn_directories, {:id => integration.id, :provider => integration.provider}
      end
      response.status.should eql 200
    end

    it "should be successful to get all the directories under the specific rackspace bucket" do
      VCR.use_cassette('rackspace_2') do
        integration = FactoryGirl.create :integration_amazons3
        get :csn_directories, {:id => integration.id, :provider => integration.provider, :bucket => integration.bucket}
      end
      response.status.should eql 200
    end
  end
end