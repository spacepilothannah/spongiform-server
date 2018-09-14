FactoryBot.define do
  to_create { |x| x.save }

  factory :request do
    url { Faker::Internet.url }
    created_at { Time.now }

    trait :denied do
      denied_at { Time.now }
    end

    trait :allowed do
      allowed_at { Time.now }
    end
  end
end
