require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Admin::UserManagementController', type: :feature do
  include Capybara::DSL
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, email: 'nicoadmin@example.com', password: 'password', role: 'admin') }
  let!(:user1) { create(:user, name: 'vendedor1', email: 'vendedor1@example.com', role: 'seller') }
  let!(:user2) { create(:user, name: 'vendedor2', email: 'vendedor2@example.com', role: 'seller') }

  before do
    login_as(admin, scope: :user)
  end

  describe 'index' do
    it 'displays list of seller users' do
      visit admin_user_management_index_path

      expect(page).to have_content('User Management - Index')
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.name)
      expect(page).to have_content(user2.email)
    end
  end

  describe 'new' do
    it 'creates a new seller user successfully' do
      visit new_admin_user_management_path

      expect(page).to have_content('New Seller User')

      fill_in 'Name', with: 'nuevoUser'
      fill_in 'Email', with: 'nuevouser@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'

      click_button 'Save'

      expect(User.last.name).to eq('nuevoUser')
      expect(User.last.email).to eq('nuevouser@example.com')
      expect(User.last.role).to eq('seller')
    end

    it 'displays error messages when creation fails' do
      visit new_admin_user_management_path

      expect(page).to have_content('New Seller User')

      click_button 'Save'

      expect(page).to have_content('prohibited this user from being saved:')
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end
  end

  describe 'edit' do
    it 'updates an existing seller user successfully' do
      visit edit_admin_user_management_path(user1)

      expect(page).to have_content('Edit Seller User')

      fill_in 'Name', with: 'userActualizado'

      click_button 'Save'

      expect(user1.reload.name).to eq('userActualizado')
    end

    it 'displays error messages when update fails' do
      visit edit_admin_user_management_path(user1)

      expect(page).to have_content('Edit Seller User')

      fill_in 'Email', with: ''
      click_button 'Save'

      expect(page).to have_content('prohibited this user from being saved:')
      expect(page).to have_content("Email can't be blank")
    end
  end

  describe 'destroy' do
    it 'deletes an existing seller user' do
      visit admin_user_management_index_path
  
      expect(page).to have_content('User Management - Index')
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
  
      delete_button = first('tr', text: user1.name).find_button('Delete')
      delete_button.click
  
      expect(page).not_to have_content(user1.name)
      expect(page).to have_content(user2.name)
      expect(User.exists?(user1.id)).to be false
    end
  end
  
  
end
