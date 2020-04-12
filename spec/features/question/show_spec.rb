# frozen_string_literal: true

require "rails_helper"

feature 'User view answers to specific question', "
  In order to read answers to question
  As a user
  I'd like to be able to view answers to question
" do
  # можно обойтись без создания вопроса, т.к. один уже создается в фабрике ответа, но я решил так более наглядно
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }
  given!(:other_questions_answer) { create(:answer) }

  scenario "User goes to questions page" do
    visit questions_path
    first('.question').click_on 'answers'

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
    expect(page).to have_no_content(other_questions_answer.body)
  end
end
