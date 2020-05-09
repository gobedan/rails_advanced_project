# frozen_string_literal: true

require "rails_helper"

feature 'User can mark answer to his question as best answer', "
  In order to get community know what helped most
  As an author of question
  I'd like to be able to mark one answer as best
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user, answers: create_list(:answer, 5)) }

  scenario 'Unauthenticated user cannot choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    scenario 'choose answer as best' do
      sign_in(user)
      visit question_path(question)

      within ".answer[data-answer-id=#{question.answers.last.id}]" do
        click_on 'Mark as best'

        expect(page).to_not have_link 'Mark as best'
        expect(page).to have_link 'Unmark as best'
      end

      expect(page).to have_selector ".answer[data-answer-id=#{question.answers.last.id}].best-answer"
      expect(page).to have_selector ".answer[data-answer-id=#{question.answers.last.id}]:first-of-type"
    end

    scenario 'choose another answer as best' do
      sign_in(user)
      visit question_path(question)

      within ".answer[data-answer-id=#{question.answers.last.id}]" do
        click_on 'Mark as best'
      end

      within ".answer[data-answer-id=#{question.answers.first.id}]" do
        click_on 'Mark as best'
      end

      expect(page).to have_selector ".answer[data-answer-id=#{question.answers.first.id}].best-answer"
      expect(page).to_not have_selector ".answer[data-answer-id=#{question.answers.last.id}].best-answer"
    end

    scenario 'unmarks answer as best' do
      sign_in(user)
      visit question_path(question)

      within ".answer[data-answer-id=#{question.answers.last.id}]" do
        click_on 'Mark as best'
        click_on 'Unmark as best'
      end

      expect(page).to_not have_selector '.best-answer'
    end

    scenario "tries to choose best answer for another person's question" do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end
