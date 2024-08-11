# frozen_string_literal: true

FactoryBot.define do
  factory :cat do
    breed { Faker::Creature::Cat.unique.breed }
    price { 250 }
    location { Faker::Address.city }
    image { Faker::LoremFlickr.image }

    trait :lviv do
      location { 'Lviv' }
    end

    trait :kharkiv do
      location { 'Kharkiv' }
    end

    trait :cheapest do
      price { 50 }
    end

    trait :cheap do
      price { 100 }
    end

    trait :pricy do
      price { 800 }
    end

    trait :priciest do
      price { 1000 }
    end
  end
end
