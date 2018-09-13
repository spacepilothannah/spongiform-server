FactoryBot.define do
  to_create { |x| x.save }

  factory :domain do
    domain { Faker::Internet.domain_name }
    allowed { true }

    trait :disallowed do
      allowed { false }
    end
  end
end
