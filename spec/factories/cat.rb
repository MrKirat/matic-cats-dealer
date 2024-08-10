# frozen_string_literal: true

FactoryBot.define do
  factory :cat do
    breed { Faker::Creature::Cat.breed }
    price { 250 }
    location { Faker::Address.city }
    image { Faker::LoremFlickr.image }

    trait :lviv do
      location { 'Lviv' }
    end

    trait :kharkiv do
      location { 'Kharkiv' }
    end

    trait :cheap do
      price { 50 }
    end

    trait :expensive do
      price { 1000 }
    end
  end
end
