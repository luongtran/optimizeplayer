require 'spec_helper'

describe "Change plan", :type => :request do

  let(:user) { FactoryGirl.create(:user) }
  let(:plan) { FactoryGirl.create(:gratis_plan) }

  it "Can you name it", js: true do
    host = "http://#{user.url}.stage.lvh.me"

    VCR.use_cassette("update_plan") do
      Capybara.current_driver = :mechanize
      new_plan = FactoryGirl.create(:selfhost_plan)
      user.account.create_customer_with_plan(plan.remote_id)
      # Sign in
      visit "#{host}/users/sign_in"
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'changeme'
      click_button 'Sign In Now'

      # Go to billing page
      visit "#{host}/account/billing"

      click_on 'Upgrade'
      expect(page).to have_content('Please select the plan that suits your needs best')
      expect(page).to have_selector(".billing-modal##{new_plan.id}")
      # Toggle modal
      
      expect(page).to have_selector(".billing-modal.open")
      within(".billing-modal##{new_plan.id}") do
        # Fill out form
        fill_in "card[name]", :with => user.name
        fill_in "card[number]", :with => '4242424242424242'
        fill_in "billing_zip", :with => '11111'
        fill_in "ccv", :with => '123'
        select '2015', from: "year"
        select 'October', from: "month"
        click_on "Submit"
      end

      # Check new plan id
      user.account.subscription.plan_id.should eql(new_plan.id)
    end

  end
end