FactoryBot.define do
  to_create { |x| x.save }

  factory :domain do
    domain { Faker::Internet.domain_name }
    created_at { Time.now }
  end
end
