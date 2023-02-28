FactoryBot.define do
  factory :tournament do
    name { FFaker::AddressUS.neighborhood }
  end
end
