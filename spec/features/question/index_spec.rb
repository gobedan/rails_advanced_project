# frozen_string_literal: true

require "rails_helper"

feature 'User view all questions list', "
  In order to select interesting answer
  As a user
  I'd like to be able to browse all questions list
" do
  given!(:question1) { create(:question) }
  given!(:question2) { create(:question) }
  
  scenario "User goes to questions page" do
    visit questions_path

    expect(page).to have_content(question1.title)
    expect(page).to have_content(question2.title)
  end
end
