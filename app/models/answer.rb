# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :answers

  validates :body, :question, presence: true

  def best?
    question.best_answer_id == id
  end
end
