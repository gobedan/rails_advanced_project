# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    author { create(:user) }

    trait :invalid do
      title { nil }
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
