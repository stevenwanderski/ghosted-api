FactoryGirl.define do
  factory :issue do
    repo
    title "MyText"
    body "MyText"
    state "open"
    number 1
    issue_id 1
  end

end
