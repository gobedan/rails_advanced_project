# frozen_string_literal: true

require "rails_helper"

feature 'User can destroy his answer', "
  In order to remove my content
  As an authenticated user
  I'd like to be able to delete my answer
" do
  given(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'User tries to delete his answer' do
    sign_in(answer.author)
    visit question_path(answer.question)
    click_on 'Delete'

    expect(page).to have_content 'Your answer deleted successfully'
    expect(page).to have_no_content answer.body
  end

  scenario "User tries to delete other person's answer" do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).to have_no_link 'Delete'
  end

  scenario "Non-authenticated user tries to delete answer" do
    visit question_path(answer.question)

    expect(page).to have_no_link 'Delete'
  end
end
