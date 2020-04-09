# frozen_string_literal: true

require "rails_helper"

feature 'User view all questions list', "
  In order to select interesting answer
  As a user
  I'd like to be able to browse all questions list
" do
  given!(:questions) { create_list(:question, 5) }

  scenario "User goes to questions page" do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
