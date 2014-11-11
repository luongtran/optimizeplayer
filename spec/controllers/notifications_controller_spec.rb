describe NotificationsController do

  let(:notification1) { FactoryGirl.create(:notification, notification_type: "Feature") }
  let(:notification2) { FactoryGirl.create(:notification, notification_type: "Bug") }
  let(:notification3) { FactoryGirl.create(:notification, notification_type: "News") }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    user.notifications << notification3
    @request.env["devise.mapping"] = Devise.mappings[:user]

    sign_in user
    @request.host = "#{user.url}.stage.lvh.me"
  end

  it "should return correct count of read notification" do
    get :index, :format => 'json'
    notifications = JSON.parse response.body
    notifications["read"].count.should == 1
  end

  it "should return correct code of respense" do
    get :index, :format => 'json'
    expect(response.status).to eq(200)
  end

  it "should return correct count of read notification" do
    get :index, :format => 'json'
    notifications = JSON.parse response.body
    notifications["read"].count.should == 1

    get :mark_as_read, :format => 'json', :id => notification2.id

    get :index, :format => 'json'
    notifications = JSON.parse response.body
    notifications["read"].count.should == 2
  end
end