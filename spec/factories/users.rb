FactoryGirl.define do
  factory :user do
    github_id { rand(123..99999) }
    username { Faker::Internet.user_name }
    access_token 12345789
    avatar "MyString"
  end
end
