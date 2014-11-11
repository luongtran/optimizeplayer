describe RegistrationsController do

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "#create" do
    it "creates account and user, assigns plan to account" do
      FactoryGirl.create(:gratis_plan)
      VCR.use_cassette('accounts/create') do
        post :create, { plan_remote_id: "gratis",
                      user: { name: "Bob", 
                              email: "fodoj@fodoj.fodoj", 
                              password: "qwerty", 
                              password_confirmation: "qwerty"} }
      end

      account = Account.find_by_name("Bobaccount")
      account.should_not be_nil

      owner = account.users.first
      owner.email.should eql "fodoj@fodoj.fodoj"
      owner.owner.should eql true
      
      account.plan.remote_id.should eql "gratis"
    end
  end
end