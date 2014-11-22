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
    expect(page).to have_content("Sorry, your passwords do not match")
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
    time = Time.now
    Timecop.freeze(time)
    User.create(:email                    => "rrearle@gmail.com",
                :password                 => "test",
                :password_confirmation    => "test",
                :password_token           => "RAdoM",
                :password_token_timestamp => time)
  end

  scenario "and requests to resest it using a correct email address" do
    visit 'users/forgot_password'
    fill_in 'email', :with => "rrearle@gmail.com"
    click_on 'Forgot my password'
    expect(page).to have_content('Please check your email')
  end

  scenario "and requests to resest it using an incorrect email address" do
    visit 'users/forgot_password'
    fill_in 'email', :with => "pass@test.com"
    click_on 'Forgot my password'
    allow_any_instance_of(Sinatra::Application).to receive(:send_password_token).and_return true
    expect(page).not_to have_content('Please check your email')
    expect(page).to have_content('Incorrect email address!')
    expect(current_path).to eq('/users/forgot_password')
  end

  scenario "and resets it using a valid password token link" do
    visit 'users/reset_password/RAdoM'
    expect(page).to have_content('Please enter a new password for rrearle@gmail.com')
    fill_in 'password', with: "test"
    fill_in 'password_confirmation', with: 'test'
    click_on 'Reset my password'
    expect(page).to have_content 'Your password has been reset. Please sign in'
  end

  scenario "and choosing unmatching passwords" do
    visit 'users/reset_password/RAdoM'
    fill_in 'password', with: "test"
    fill_in 'password_confirmation', with: 'best'
    click_on 'Reset my password'
    expect(page).not_to have_content 'Your password has been reset. Please sign in'
    expect(page).to have_content 'Sorry, your passwords do not match'
    expect(current_path).to eq '/users/new_password'
  end

  scenario "and cannot reset with an password token link older than one hour" do
    Timecop.travel(Time.now+60*65)
    visit 'users/reset_password/RAdoM'
    expect(page).to have_content('Sorry, there were the following problems with the form: This link has expired.')
    expect(current_path).to eq ('/users/forgot_password')
  end

  after do
    Timecop.return
  end

end

feature 'links for user management on hompage' do

  scenario 'for sign-in' do
    visit '/'
    click_button 'Sign in'
    expect(current_path).to eq '/sessions/new'
  end

  scenario 'for sign-up' do
    visit '/'
    click_button 'Sign up'
    expect(current_path).to eq '/users/new'
  end

end
