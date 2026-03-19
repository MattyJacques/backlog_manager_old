# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User signs in' do
  it 'with valid credentials' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(page).to have_text 'Signed in successfully.'
    expect(page).to have_selector '.profile-dropdown'
    expect(page).to have_current_path root_path
  end

  it 'with invalid credentials' do
    user = build(:user)

    visit new_user_session_path

    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(page).to have_text 'Invalid username or password.'
    expect(page).not_to have_selector '.profile-dropdown'
  end
end
