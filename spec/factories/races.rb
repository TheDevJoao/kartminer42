FactoryBot.define do
  factory :race do
    tournament
    date { FFaker::Time.date - 10.days }
    place { FFaker::Address.city }
  end
end
