# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose(:question)
  expose :answer, -> { Answer.new }

  def create
    question.author = current_user
    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'Your question deleted successfully'
      redirect_to questions_path
    else
      flash[:error] = 'Delete is not permitted!'
      redirect_to question_path(question)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
