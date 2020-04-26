# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer
  expose :question
  expose(:answers, ancestor: :question)

  def create
    answer.author = current_user
    answer.question = question
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def best
    answer.toggle_best
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
