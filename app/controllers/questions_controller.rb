# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose(:question) do
    params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end
  expose :answer, -> { Answer.new }

  # не придумал как реализовать инстанцирование линков для new и show средствами decent exposure

  def show
    answer.links.new
  end

  def new
    question.links.new
  end

  def create
    question.update(question_params)
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

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[name url _destroy id])
  end
end
