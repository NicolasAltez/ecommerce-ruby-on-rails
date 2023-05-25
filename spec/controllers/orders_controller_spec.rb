require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "GET #index" do
    let(:user) { create(:user, role: "buyer") }
    it "assigns orders belonging to the current user to @orders and renders the index template" do
      sign_in user
      order = create(:order, user: user)
      get :order_history
      expect(assigns(:orders)).to eq([order])
      expect(response).to render_template(:order_history)
    end

    it "redirects to the sign-in page if the user is not authenticated" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:user) { create(:user, role: "buyer") }
      let(:product) { create(:product, user: user) }
      before { sign_in user }
  
      it "creates a new order and redirects to the order history page" do
        session[:cart] = { product.id => 1 }
        post :create, params: { user_id: user.id }
        expect(user.orders.count).to eq(1)
        expect(session[:cart]).to eq({})
        expect(response).to redirect_to(order_history_path)
      end
  
      it "redirects to the products page if there are no products in the cart" do
        session[:cart] = {}
        post :create, params: { user_id: user.id }
        expect(response).to redirect_to(shopping_cart_path)
      end
    end
  

    it "redirects to the sign-in page if the user is not authenticated" do
      post :create
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET #order_history" do
    let(:user) { create(:user, role: "buyer") }
    it "assigns orders belonging to the current user to @orders and renders the order history template" do
      sign_in user
      order = create(:order, user: user)
      get :order_history
      expect(assigns(:orders)).to eq([order])
      expect(response).to render_template(:order_history)
    end

    it "redirects to the sign-in page if the user is not authenticated" do
      get :order_history
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
