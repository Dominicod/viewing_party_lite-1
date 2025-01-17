# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie | Index' do
  describe 'As a user when I visit the Movies Results Page', :vcr do
    before(:each) do
      @user1 = User.create!(name: 'jojo binks', email: 'jojo_binks@gmail.com', password: 'password_1', password_confirmation: 'password_1')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit user_discover_index_path
    end
    context 'Happy Path' do
      it 'has a button to discover top rated movies' do
        click_button 'Discover Top Rated Movies'
        expect(current_path).to eq(user_movies_path)
        expect(page).to have_content('The Shawshank Redemption')
      end
      it 'has a search function that displays matching movies' do
        expect(page).to have_button('Search')

        fill_in :search, with: 'Impossible Things'
        click_on 'Search'
        expect(page).to have_content('Impossible Things')
      end
      it 'has a button to return to discover page' do
        visit user_movies_url

        expect(page).to have_button('Discover Movies')
        click_button 'Discover Movies'
        expect(page.current_path).to eq(user_discover_index_path)
      end

      it 'has text field to search key words then redirects to matching list' do
        expect(page).to have_button('Search')

        fill_in :search, with: 'Shawshank Redemption'
        click_on 'Search'
        expect(page).to have_content('Shawshank Redemption')
        expect(page.current_path).to eq(user_movies_path)
      end
    end
    context 'Sad Path' do
      it 'if I click submit without filling in the form I am greeted with an error message' do
        expect(page).to have_button('Search')
        click_on 'Search'
        within('.container') do
          expect(page).to have_content('Error: Incorrect information entered')
        end
        expect(page.current_path).to eq(user_discover_index_path)
      end
    end
  end
end
