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

    scenario "submits an anwers" do
      fill_in 'Your answer', with: 'answer text here'
      click_on 'Submit answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer text here'
    end

    scenario "submits an anwers with errors"
    # do
    #   click_on 'Submit answer'

    #   expect(page).to have_content "Body can't be blank"
    # end
  end

  scenario "Unauthenticated user tries to add answer" do
    visit question_path(question)
    click_on 'Submit answer'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
