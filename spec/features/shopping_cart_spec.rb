require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'ShoppingCart', type: :feature do
  include Capybara::DSL
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper

  let!(:user) { create(:user, role: 'buyer') }
  let!(:product) { create(:product, user: user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'Add a product to the cart' do
    it 'increases the quantity in the cart' do
      visit root_path

      select '3', from: 'Quantity'
      click_button 'Add to Cart'

      expect(page).to have_content('Current Items')
      expect(page).to have_content("#{product.name} - #{number_to_currency(product.price)} x 3")
    end
  end

  describe 'Remove a product from the cart' do
    before do
      visit root_path
      select '2', from: 'Quantity'
      click_button 'Add to Cart'
      visit shopping_cart_path
    end

    it 'decreases the quantity in the cart' do
      select '1', from: 'Remove Quantity'
      click_button 'Remove'

      expect(page).to have_content("#{product.name} - #{number_to_currency(product.price)} x 1")
    end

    it 'removes the item from the cart when removing all' do
      click_button 'Remove All'

      expect(page).not_to have_content(product.name)
    end
  end
  
  describe 'Calculate the total price in the cart' do
    before do
      visit root_path
      select '2', from: 'Quantity'
      click_button 'Add to Cart'
      visit shopping_cart_path
    end
    
    it 'shows the correct total price' do
      expect(page).to have_content("Total Price: #{number_to_currency(product.price * 2)}")
    end
  end

  describe 'View empty shopping cart' do
    it 'displays "Your shopping cart is empty"' do
      visit shopping_cart_path

      expect(page).to have_content('Your shopping cart is empty.')
    end
  end  
end
