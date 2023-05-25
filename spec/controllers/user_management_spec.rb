require 'rails_helper'

RSpec.describe Admin::UserManagementController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:admin_user) { create(:user, role: "admin") }
  let(:seller_user) { create(:user, role: "seller") }

  describe "GET #index" do
    context "when authenticated as admin" do
      before { sign_in admin_user }

      it "assigns @users with seller role" do
        get :index
        expect(assigns(:users)).to eq(User.where(role: "seller"))
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when authenticated as seller" do
      before { sign_in seller_user }

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #new" do
    context "when authenticated as admin" do
      before { sign_in admin_user }

      it "assigns a new user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when authenticated as seller" do
      before { sign_in seller_user }

      it "redirects to root path" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when authenticated as admin" do
      before { sign_in admin_user }

      context "with valid parameters" do
        let(:valid_params) do
          {
            user: {
              name: "John Doe",
              email: "john@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        end

        it "creates a new user with seller role" do
          post :create, params: valid_params
          expect(User.last.role).to eq("seller")
        end

        it "redirects to the index page with a success notice" do
          post :create, params: valid_params
          expect(response).to redirect_to(admin_user_management_index_path)
          expect(flash[:notice]).to eq("User was successfully created.")
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) do
          {
            user: {
              name: "",
              email: "john@example.com",
              password: "password",
              password_confirmation: "different_password"
            }
          }
        end

        it "does not create a new user" do
          expect {
            post :create, params: invalid_params
          }.not_to change(User, :count)
        end

        it "renders the new template" do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end

    context "when authenticated as seller" do
      before { sign_in seller_user }

      it "redirects to root path" do
        post :create, params: {}
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in page" do
        post :create, params: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
