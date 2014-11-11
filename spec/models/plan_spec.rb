describe Plan do
  it "#features lists features" do
    plan = FactoryGirl.create(:gratis_plan, number_of_embeds: 5,
                                          number_of_jobs: 1,
                                          number_of_users: 1,
                                          has_branding: true,
                                          has_ads: true,
                                          can_add_cta: false)

    plan.features.should eql ["<b>5</b> EMBEDS", "<b>1</b> USER", "<b>OPTIMIZEPLAYER BRANDING</b>", "<b>Ads</b>", "", "<b>1</b> ENCODING JOB", "<b>CAN ENCODE</b>", "<b>OPTIMIZEPLAYER HOSTED</b>", "<b>2048</b> BANDWIDTH"]

    plan.update_attributes(number_of_embeds: -1, number_of_jobs: -1, number_of_users: -1)
    plan.reload
    plan.features.should eql ["<b>UNLIMITED</b> EMBEDS", "<b>UNLIMITED</b> USERS", "<b>OPTIMIZEPLAYER BRANDING</b>", "<b>Ads</b>", "", "<b>UNLIMITED</b> ENCODING JOBS", "<b>CAN ENCODE</b>", "<b>OPTIMIZEPLAYER HOSTED</b>", "<b>2048</b> BANDWIDTH"]

    plan.update_attributes(number_of_embeds: -1, number_of_jobs: -1, number_of_users: -1, has_branding: false, has_ads: false, can_add_cta: true)
    plan.reload
    plan.features.should eql ["<b>UNLIMITED</b> EMBEDS", "<b>UNLIMITED</b> USERS", "<b>UNBRANDED</b>", "", "<b>PREMIUM FEATURES</b>", "<b>UNLIMITED</b> ENCODING JOBS", "<b>CAN ENCODE</b>", "<b>OPTIMIZEPLAYER HOSTED</b>", "<b>2048</b> BANDWIDTH"]
  end
end
