FactoryGirl.define do
  factory :videopage do
    # project FactoryGirl.create(:project)
    project_id 1
    user FactoryGirl.create(:user)
    template {}
    widgets nil
    seo nil
    settings nil
    slug 'test'
  end
end
