# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User", inverse_of: :questions
  belongs_to :best_answer, class_name: "Answer", optional: true

  validates :title, :body, presence: true
  validate :best_answer_inclusion

  private

  def best_answer_inclusion
    return if best_answer.nil? || best_answer.question == self

    errors.add(:base, "answer is not associated with question")
  end
end
