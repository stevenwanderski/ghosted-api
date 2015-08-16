FactoryGirl.define do
  factory :user do
    github_id { rand(123..99999) }
    username { Faker::Internet.user_name }
    access_token "1c9744f226481db184b5c95600fc4e"
    avatar "some-url"
    repos_loaded true
  end
end
