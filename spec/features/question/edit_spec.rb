# frozen_string_literal: true

require "rails_helper"

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user cannot edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
        expect(page).to_not have_selector 'textfield'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'
        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(other_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario "adds attachments to question", js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
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

    scenario 'deletes attachment of his question', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        attach_file 'Files', Rails.root.join('spec/spec_helper.rb')
        click_on 'Save'

        click_on 'x'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    given!(:question_with_files) { create(:question, :with_attachments) }

    scenario "tries to delete attachment of other person's question", js: true do
      sign_in(other_user)
      visit question_path(question_with_files)

      within '.question' do
        expect(page).to_not have_link 'x'
      end
    end
  end
end
