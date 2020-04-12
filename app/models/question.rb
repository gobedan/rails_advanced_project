# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User", inverse_of: :questions

  validates :title, :body, presence: true
end
