# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose(:question)
  expose(:answer, ancestor: :question, attributes: :body)
  expose(:answers) { Question.find(params[:question_id]).answers }

  def create
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

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
