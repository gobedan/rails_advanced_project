# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
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
    question.update(question_params) if current_user.author_of?(question)
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

  def assign_best
    if current_user.author_of?(question)
      question.best_answer_id = params[:answer_id]
      flash[:notice] = 'New best answer successlully assigned!'
    else
      flash[:error] = 'Assigning best answer is not permitted!'
    end
    redirect_to question_path(question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
