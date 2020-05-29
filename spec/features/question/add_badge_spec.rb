# frozen_string_literal: true

require 'rails_helper'

feature 'User can add badge to question', "
  In order to award best answer's author
  As an question's autor
  I'd like to be able to add badge
" do
  given(:user) { create(:user) }

  scenario 'User adds badge when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.badge' do
      fill_in 'Badge title', with: 'winner winner'
      attach_file 'Badge image', Rails.root.join('app/assets/images/winner.png')
    end

    click_on 'Ask'

    fill_in 'Your answer', with: 'answer text here'
    click_on 'Submit answer'
    click_on 'Mark as best'

    visit badges_path
    expect(page).to have_content 'winner winner'
    # как лучше проверить наличие картинки ?
    expect(page).to have_selector '.badge > img'
  end
end
