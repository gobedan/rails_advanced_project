# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose(:answer, ancestor: :question, attributes: :body)
  expose(:answers) { Question.find(params[:question_id]).answers }

  def create
    answer.question = Question.find(params[:question_id])
    if answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:alert] = 'Error. Answer not saved'
    end
    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit!
  end
end
