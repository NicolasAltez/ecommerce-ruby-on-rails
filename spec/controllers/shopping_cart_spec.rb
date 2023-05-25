require 'rails_helper'

RSpec.describe ShoppingCartController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:product) { create(:product, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all products to @products and renders the index template" do
      get :index
      expect(assigns(:products)).to eq(Product.all)
      expect(response).to render_template(:index)
    end
  end

  describe "POST #add_to_cart" do
    before do
      session[:cart] = {}
    end

    it "adds the product to the cart and redirects to the shopping cart page" do
      post :add_to_cart, params: { id: product.id, quantity: 1 }
      expect(session[:cart][product.id.to_s]).to eq(1)
      expect(response).to redirect_to(shopping_cart_path)
    end
  end

  describe "POST #remove_from_cart" do
    before do
      session[:cart] = { product.id.to_s => 2 }
    end

    it "removes the specified quantity of the product from the cart and redirects to the shopping cart page" do
      post :remove_from_cart, params: { id: product.id, quantity: 1 }
      expect(session[:cart][product.id.to_s]).to eq(1)
      expect(response).to redirect_to(shopping_cart_path)
    end

    it "removes the product from the cart if the quantity becomes zero" do
      post :remove_from_cart, params: { id: product.id, quantity: 2 }
      expect(session[:cart]).not_to have_key(product.id.to_s)
    end
  end

  describe "POST #remove_all_from_cart" do

    before do
      session[:cart] = { product.id.to_s => 2 }
    end

    it "removes all quantities of the product from the cart and redirects to the shopping cart page" do
      post :remove_all_from_cart, params: { id: product.id }
      expect(session[:cart]).not_to have_key(product.id.to_s)
      expect(response).to redirect_to(shopping_cart_path)
    end
  end
end
