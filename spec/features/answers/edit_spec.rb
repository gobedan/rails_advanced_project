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
  given(:gist_url) { 'https://gist.github.com/gobedan/4651d1193e459cf6c90c34ee93d071ac' }

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

    scenario "adds links to answer", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answer' do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
        click_on 'Save'

        expect(page).to have_link 'My gist'
      end
    end

    scenario "deletes links from answer", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answer' do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
        click_on 'Save'

        click_on 'Edit'
        click_on 'remove link'
        click_on 'Save'

        expect(page).to_not have_link 'My gist'
      end
    end

    scenario 'deletes attachment of his answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answer' do
        click_on 'Edit'
        attach_file 'Files', Rails.root.join('spec/spec_helper.rb')
        click_on 'Save'

        click_on 'x'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    given!(:answer_with_files) { create(:answer, :with_attachments, author: user, question: create(:question)) }

    scenario "tries to delete attachment of other person's question", js: true do
      sign_in(other_user)
      visit question_path(answer_with_files.question)

      within '.answer' do
        expect(page).to_not have_link 'x'
      end
    end
  end
end
