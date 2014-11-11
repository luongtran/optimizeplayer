describe ProjectsController do

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "#show" do
    before :each do
      Project.any_instance.stub(:cdn_url).and_return("http://yandex.ru")
    end

    it "renders video if allowed urls of project not specified" do
      project = FactoryGirl.create(:project)
      @request.stub(:referer).and_return("http://example.com")
      post :show, {id: project.cid}
      response.status.should eql 200
    end

    it "renders video if referer is included in allowed urls of project" do
      project = FactoryGirl.create(:project, allowed_urls: "yandex.ru,fodoj.com")
      @request.stub(:referer).and_return("http://fodoj.com")
      post :show, {id: project.cid}
      response.status.should eql 200
    end

    it "renders error if referer is not included in allowed urls" do
      project = FactoryGirl.create(:project, allowed_urls: "fodoj.com")
      @request.stub(:referer).and_return("http://example.com")
      post :show, {id: project.cid}
      response.status.should eql 403
    end
  end
end