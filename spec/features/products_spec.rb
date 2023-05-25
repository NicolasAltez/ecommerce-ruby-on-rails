require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Products', type: :feature do
  include Capybara::DSL
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, role: 'seller') }

  before do
    login_as(user, scope: :user)
  end

  describe 'Create a new product' do
    it 'creates a new product successfully' do
      visit new_product_path

      fill_in 'Name', with: 'Remera'
      fill_in 'Description', with: 'remera manga corta'
      fill_in 'Price', with: '9.99'

      click_button 'Save'

      expect(page).to have_content('Remera')
      expect(page).to have_content('remera manga corta')
      expect(page).to have_content('9.99')
    end

    it 'displays error messages for invalid input' do
      visit new_product_path
      fill_in 'Name', with: ''

      click_button 'Save'
     
      expect(page).to have_content('prohibited this product from being saved')
      expect(page).to have_content("Name can't be blank")
    end
  end

  describe 'Edit a product' do
    let!(:product) { create(:product, user: user) }

    it 'updates the product successfully' do
      visit edit_product_path(product)

      fill_in 'Name', with: 'Remera M'
      click_button 'Save'

      expect(page).to have_content('Remera M')
    end

    it 'displays error messages for invalid input' do
      visit edit_product_path(product)

      fill_in 'Name', with: ''
      click_button 'Save'

      expect(page).to have_content('prohibited this product from being saved')
      expect(page).to have_content("Name can't be blank")
    end
  end

  describe 'Delete a product' do
    let!(:product) { create(:product, user: user) }

    it 'deletes the product successfully' do
      visit products_path

      click_link 'Delete'

      expect(page).not_to have_content(product.name)
    end
  end
end
