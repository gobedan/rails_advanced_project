# frozen_string_literal: true

require "rails_helper"

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
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

    scenario 'edits his answer with errors', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Edit answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario "adds attachments to answer", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answer' do
        click_on 'Edit'
        attach_file 'Files', Rails.root.join('spec/spec_helper.rb')
        click_on 'Save'

        click_on 'Edit'
        attach_file 'Files', Rails.root.join('spec/rails_helper.rb')
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
