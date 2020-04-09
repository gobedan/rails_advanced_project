# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: :author_id, inverse_of: :questions

  validates :title, :body, presence: true
end
