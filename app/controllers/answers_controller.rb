# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose(:question)
  expose(:answer)
  expose(:answers, ancestor: :question)

  def create
    answer.author = current_user
    # почему без этой строчки не работает хотя с decent exposure должно?
    answer.question = question
    if answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:alert] = 'Error. Answer not saved'
      # решение через паршел ошибок не получилось, см. коммент во вьюхе
      # render 'questions/show'
    end
    redirect_to question_path(question)
  end

  def destroy
    answer.destroy
    redirect_to question_path(question), notice: 'Your answer deleted successfully'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
