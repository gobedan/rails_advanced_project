# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer
  expose :question
  expose(:answers, ancestor: :question)

  def create
    answer.author = current_user
    answer.question = question
    if answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_path(question)
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer deleted successfully'
      redirect_to question_path(answer.question)
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
