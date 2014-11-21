require 'spec_helper'
require_relative '../helpers/session_helpers'

include SessionHelpers

feature "User signs up" do

  scenario "when being logged out" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")
  end

  scenario "with a password that doesn't match"do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do
    expect { sign_up }.to change(User, :count).by(1)
    expect { sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User signs in" do

  before(:each) do
    User.create(:email                 => "test@test.com",
                :password              => "test",
                :password_confirmation => "test")
  end

  scenario "with correct credentials" do
    visit "/"
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in("test@test.com", "test")
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit "/"
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in("test@test.com", "wrong")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature "User signs out" do

  before(:each) do
    User.create(:email                 => "test@test.com",
                :password              => "test",
                :password_confirmation => "test")
  end

  scenario "while being signed in" do
    sign_in("test@test.com", "test")
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature "Person forgets their password" do

  before(:each) do
    User.create(:email                    => "test@test.com",
                :password                 => "test",
                :password_confirmation    => "test",
                :password_token           => "RAdoM",
                :password_token_timestamp => Time.now)
  end

  scenario "and requests to resest it using a correct email address" do
    visit 'users/forgot_password'
    fill_in 'email', :with => "test@test.com"
    click_on 'Forgot my password'
    expect(page).to have_content('Please check your email')
  end

  scenario "and requests to resest it using an incorrect email address" do
    visit 'users/forgot_password'
    fill_in 'email', :with => "pass@test.com"
    click_on 'Forgot my password'
    expect(page).not_to have_content('Please check your email')
    expect(page).to have_content('Incorrect email address!')
    expect(current_path).to eq('/users/forgot_password')
  end

  scenario "and resets it using a valid password token link" do
    visit 'users/reset_password/RAdoM'
    expect(page).to have_content('Please enter a new password for test@test.com')
    fill_in 'password', with: "test"
    fill_in 'password_confirmation', with: 'test'
    click_on 'Reset my password'
    expect(page).to have_content 'Your password has been reset. Please sign in'
  end

   before(:each) do
    User.create(:email                    => "test@test.com",
                :password                 => "test",
                :password_confirmation    => "test",
                :password_token           => "RAdoM",
                :password_token_timestamp => Time.new(2400))
  end


  scenario "and cannot reset with an expired password token link" do
    visit 'users/reset_password/RAdoM'
    expect(page).to have_content('Sorry, there were the following problems with the form: This link has expired.')
    expect(current_path).to eq ('/users/forgot_password')
  end
end

#scenario password_confirmation incorrect
#scenario send email with token
