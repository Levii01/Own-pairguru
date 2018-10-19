FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Date.today }

    trait :with_comment do
      after(:create) do |user|
        create_list :comment, 4, user: user
      end
    end
    
    trait :with_old_comment do
      after(:create) do |user|
        create_list :comment, 4, user: user, created_at: 10.days.ago, updated_at: 10.days.ago
      end
    end
  end
end
