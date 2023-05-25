require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:seller) { create(:user, role: :seller) }
  before { sign_in seller }

  describe "GET #index" do
    it "assigns products belonging to the current user to @products and renders the index template" do
      product = FactoryBot.create(:product, user: seller)
      get :index
      expect(assigns(:products)).to eq([product])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "renders the new product template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new product" do
        expect {
          post :create, params: { product: attributes_for(:product) }
        }.to change(Product, :count).by(1)
      end

      it "redirects to the products index page" do
        post :create, params: { product: attributes_for(:product) }
        expect(response).to redirect_to(products_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new product" do
        expect {
          post :create, params: { product: { name: '' } }
        }.not_to change(Product, :count)
      end

      it "renders the new template" do
        post :create, params: { product: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested product to @product and renders the edit template" do
      product = FactoryBot.create(:product, user: seller)
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:product) { FactoryBot.create(:product, user: seller) }

    context "with valid parameters" do
      it "updates the requested product and redirects to the products index page" do
        patch :update, params: { id: product.id, product: { name: 'peñarol' } }
        product.reload
        expect(product.name).to eq('peñarol')
        expect(response).to redirect_to(products_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested product and renders the edit template" do
        patch :update, params: { id: product.id, product: { name: '' } }
        product.reload
        expect(product.name).not_to eq('')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:product) { FactoryBot.create(:product, user: seller) }

    it "destroys the requested product" do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products index page" do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_path)
    end
  end
end
