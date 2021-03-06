# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional information
  As an question's autor
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/gobedan/4651d1193e459cf6c90c34ee93d071ac' }
  given(:google_url) { 'http://google.ru' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'google'
    fill_in 'Url', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'google', href: google_url
  end

  scenario 'User adds GitHub Gist link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_selector('.gist-data')
  end
end
