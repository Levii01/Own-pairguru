FactoryBot.define do
  factory :comment do
    body "Awesome Comment! For awesome movie!"
    user
    movie
  end
end
