FactoryGirl.define do
  factory :repo do
    repo_id { rand(123..99999) }
    name { Faker::Internet.slug }
  end
end