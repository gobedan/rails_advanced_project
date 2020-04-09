# frozen_string_literal: true

require 'rails_helper'

feature 'User can log out', "
  In order to leave session
  As a authenticated user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  scenario 'User tries to log out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
  end
end
