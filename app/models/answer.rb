# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :author_id, inverse_of: :answers

  validates :body, :question, presence: true
end
