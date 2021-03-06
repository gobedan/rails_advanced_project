# frozen_string_literal: true

require "rails_helper"

feature 'User can create answer', "
  In order to give help community with problem
  As an authenticated user
  I'd like to be able to submit answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "submits an anwers", js: true do
      fill_in 'Your answer', with: 'answer text here'
      click_on 'Submit answer'

      expect(page).to have_content 'answer text here'
    end

    scenario "submits an anwers with errors", js: true do
      click_on 'Submit answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "submits an answer with attached files", js: true do
      fill_in 'Your answer', with: 'text text text'

      attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_on 'Submit answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unauthenticated user tries to add answer" do
    visit question_path(question)
    click_on 'Submit answer'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
