# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :answers
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, :question, presence: true

  def toggle_best
    Answer.transaction do
      question.answers.where(best: true).update(best: false)
      update(best: !best)
      question.badge&.update(reciever: question.answers.find_by(best: true)&.author)
    end
  end
end
