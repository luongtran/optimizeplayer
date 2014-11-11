FactoryGirl.define do
  factory :project do
    cid "pr0ject"
    title "MyProject"
    folder FactoryGirl.create(:folder)
    dimensions "responsive"
  end
end
