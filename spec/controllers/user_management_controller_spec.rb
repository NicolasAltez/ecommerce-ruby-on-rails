require 'rails_helper'

RSpec.describe Admin::UserManagementController, type: :controller do
  include Devise::Test::ControllerHelpers
  before { sign_in user }

  let(:user) { create(:user, role: "admin") }

  describe "GET #index" do
    it "assigns @users with seller role" do
      get :index
      expect(assigns(:users)).to eq(User.where(role: "seller"))
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns a new user and renders the new template" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            name: "nico altez",
            email: "altez@gmail.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "creates a new user with seller role and redirects to the index page" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)

        expect(User.last.role).to eq("seller")
        expect(response).to redirect_to(admin_user_management_index_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "facundo@gmail.com",
            password: "password",
            password_confirmation: "different_password"
          }
        }
      end

      it "does not create a new user and renders the new template" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:user_to_edit) { create(:user, role: "seller") }

    it "assigns the user to edit and renders the edit template" do
      get :edit, params: { id: user_to_edit.id }
      expect(assigns(:user)).to eq(user_to_edit)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    let(:user_to_update) { create(:user, role: "seller") }

    context "with valid parameters" do
      let(:valid_params) do
        {
          id: user_to_update.id,
          user: {
            name: "acosta",
            email: "acosta@gmail.com",
            password: "new_password",
            password_confirmation: "new_password"
          }
        }
      end

      it "updates the user and redirects to the index page" do
        put :update, params: valid_params
        user_to_update.reload
        expect(user_to_update.name).to eq("acosta")
        expect(user_to_update.email).to eq("acosta@gmail.com")
        expect(response).to redirect_to(admin_user_management_index_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          id: user_to_update.id,
          user: {
            name: "",
            email: "fernandez@example.com",
            password: "new_password",
            password_confirmation: "different_password"
          }
        }
      end

      it "does not update the user and renders the edit template" do
        put :update, params: invalid_params
        user_to_update.reload
        expect(user_to_update.email).not_to eq("fernandez@example.com")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user_to_destroy) { create(:user, role: "seller") }

    it "destroys the user and redirects to the index page with a success notice" do
      expect {
        delete :destroy, params: { id: user_to_destroy.id }
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(admin_user_management_index_path)
      expect(flash[:notice]).to eq("User was successfully destroyed.")
    end
  end
end
