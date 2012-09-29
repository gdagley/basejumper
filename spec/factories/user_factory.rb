FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              'monkey'
    password_confirmation 'monkey'
  end
end
