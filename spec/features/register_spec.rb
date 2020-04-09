# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', "
  In order to sign in
  As a guest user
  I'd like to be able to register
" do
  given(:user) { create(:user) }

  scenario 'User tries to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    # нужно ли попробовать залогинится под новым пользователем или проверки по сообщению достаточно?
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to register with invalid credentials' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user_wrong'
    fill_in 'Password', with: '1234'
    fill_in 'Password confirmation', with: '1234'
    click_on 'Sign up'

    expect(page).to have_content '2 errors prohibited this user from being saved:'
  end

  scenario 'User tries to register with already registered email' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
