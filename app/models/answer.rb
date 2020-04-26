# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :answers

  validates :body, :question, presence: true

  def toggle_best
    Answer.find_by(question_id: question, best: true)&.update(best: false)
    self.best = !best
    save
  end
end
