# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landing Page | Index', type: :feature do
  describe 'As a user when I visit the Landing Page,' do
    before(:each) { visit root_path }
    let(:user1) { User.create!(name: 'jojo binks', email: 'jojo_binks@gmail.com') }
    let(:user2) { User.create!(name: 'bobby', email: 'bobby@yahoo.com') }
    let(:user3) { User.create!(name: 'marissa nicole', email: 'marissa.nicole99@gmail.com') }
    it 'I see the title of the Applications' do
      within('#application_title') do
        expect(page).to have_content 'Viewing Party'
      end
    end
    it 'I see a button to create a new user' do
      within('#user_creation') do
        expect(page).to have_button('#create_user', href: new_user_path)
      end
    end
    it 'I see a list of existing users which links to each users dashboard' do
      within('#current_users') do
        within('#user-1') do
          expect(page).to have_link("#{user1.email}'s dashboard", href: user_path(user1.id))
          expect(page).to_not have_link("#{user2.email}'s dashboard", href: user_path(user2.id))
          expect(page).to_not have_link("#{user3.email}'s dashboard", href: user_path(user3.id))
        end
        within('#user-2') do
          expect(page).to have_link("#{user2.email}'s dashboard", href: user_path(user2.id))
          expect(page).to_not have_link("#{user1.email}'s dashboard", href: user_path(user1.id))
          expect(page).to_not have_link("#{user3.email}'s dashboard", href: user_path(user3.id))
        end
        within('#user-3') do
          expect(page).to have_link("#{user3.email}'s dashboard", href: user_path(user3.id))
          expect(page).to_not have_link("#{user1.email}'s dashboard", href: user_path(user1.id))
          expect(page).to_not have_link("#{user2.email}'s dashboard", href: user_path(user2.id))
        end
      end
    end
    it 'I see a link back to the home page' do
      within('#home_page_link') do
        expect(page).to have_link('#home')
        click_on '#home'
        expect(page.current_path).to eq root_path
      end
    end
  end
end
