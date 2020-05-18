# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "MyAnwerText#{n}"
  end

  factory :answer do
    body
    question
    author { create :user }

    trait :invalid do
      body { nil }
    end

    trait :with_attachments do
      files do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')),
          Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))
        ]
      end
    end
  end
end
