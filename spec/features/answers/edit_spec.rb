# frozen_string_literal: true

require "rails_helper"

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Edit answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario "tries to edit other user's answer"
  end
end
