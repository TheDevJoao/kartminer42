FactoryBot.define do
  factory :racer do
    name { FFaker::Name.name }
    born_at { FFaker::Time.date(year_range: 5) - 21.years }
    image_url { FFaker::Image.url }
  end

  trait :with_inappropriate_age do
    born_at { 17.years.ago }
  end

  trait :valid_url do
    image_url { 'https://shouldpass.com/image.png' }
  end

  trait :invalid_url do
    image_url { 'invalid.lol' }
  end
end
