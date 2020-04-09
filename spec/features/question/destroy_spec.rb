# frozen_string_literal: true

require "rails_helper"

feature 'User can destroy his question', "
  In order to remove my content
  As an authenticated user
  I'd like to be able to delete my question
" do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'User tries to delete his question' do
    sign_in(question.author)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question deleted successfully'
    expect(page).to have_no_content question.title
  end

  scenario "User tries to delete other person's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_no_link 'Delete'
  end
end
