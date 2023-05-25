require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Order Management', type: :feature do
  include Capybara::DSL
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper

  let(:user) { create(:user, email: 'test@example.com', password: 'password', role: 'buyer') }

  before do
    login_as(user, scope: :user)
  end

  describe 'User can view order history' do
    it 'displays order history correctly' do
      product1 = create(:product, name: 'Product 1', description: 'Description 1', price: 10, user: user)
      product2 = create(:product, name: 'Product 2', description: 'Description 2', price: 20, user: user)
      order = user.orders.create

      order.products << [product1, product2]
      order.order_total = product1.price + product2.price
      order.save

      visit order_history_path

      expect(page).to have_content('Order History')

      within '.order-history-table' do
        expect(page).to have_content(order.created_at.strftime('%Y-%m-%d %H:%M:%S'))
        expect(page).to have_content(product1.name)
        expect(page).to have_content(product2.name)
        expect(page).to have_content(number_to_currency(order.order_total))
      end
    end

    it 'displays "No orders found" when order history is empty' do
      visit order_history_path

      expect(page).to have_content('Order History')
      expect(page).to have_content('No orders found')
    end
  end

  describe 'User can place an order' do
    it 'creates a new order successfully' do
      product = create(:product, name: 'Product 1', description: 'Description 1', price: 10, user: user)

      allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:cart).and_return({ product.id.to_s => 1 })

      visit order_history_path

      expect(page).to have_current_path(order_history_path)

      expect(Order.last.user).to eq(user)
      expect(Order.last.products).to include(product)
      expect(Order.last.order_total).to eq(product.price)
    end
  end
end
