FactoryGirl.define do
  factory :repo do
    repo_id { rand(123..99999) }
    name { Faker::Internet.slug }
    full_name { "#{Faker::Internet.slug}/#{Faker::Internet.slug}" }
  end
end