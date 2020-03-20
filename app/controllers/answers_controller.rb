# frozen_string_literal: true

class AnswersController < ApplicationController
  expose(:answer, ancestor: :question)
  expose(:answers) { Question.find(params[:question_id]).answers }
  
  def create
    answer.question = Question.find(params[:question_id])
    if answer.save
      redirect_to question_answer_path(answer.question, answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_answer_path(params[:question_id], answer)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to question_answers_path(params[:question_id])
  end
  
  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
