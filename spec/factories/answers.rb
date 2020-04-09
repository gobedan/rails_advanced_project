# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "MyAnwerText#{n}"
  end

  factory :answer do
    body
    question { create :question }

    trait :invalid do
      body { nil }
    end
  end
end
