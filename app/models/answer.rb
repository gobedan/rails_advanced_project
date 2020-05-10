# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :answers

  has_many_attached :files

  validates :body, :question, presence: true

  def toggle_best
    Answer.transaction do
      question.answers.where(best: true).update(best: false)
      update(best: !best)
    end
  end
end
