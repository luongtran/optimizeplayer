describe Subscription do 
	
	let(:user) { FactoryGirl.create(:user) }
  	let(:plan) { FactoryGirl.create(:gratis_plan) }
  	let(:new_plan) { FactoryGirl.create(:selfhost_plan) }

  	it "should update plan" do
  		VCR.use_cassette("update_plan") do
	      user.account.create_customer_with_plan plan.remote_id
	      user.account.subscription.update_subscription new_plan.id
	      user.account.subscription.plan_id.should eql(new_plan.id)
	    end
  	end

end