# frozen_string_literal: true

require 'rails_helper'

feature 'User cann add links to answer', "
  In order to provide additional information
  As an answer's autor
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/gobedan/4651d1193e459cf6c90c34ee93d071ac' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Submit answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
