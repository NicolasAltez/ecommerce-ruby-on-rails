require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
 include Devise::Test::ControllerHelpers
  describe "#after_sign_in_path_for" do
    context "when user is an admin" do
      it "redirects to the admin user management index path" do
        admin_user = create(:user, role: "admin")
        sign_in admin_user

        expect(controller.after_sign_in_path_for(admin_user)).to eq(admin_user_management_index_path)
      end
    end

    context "when user is a seller" do
      it "redirects to the products path" do
        seller_user = create(:user, role: "seller")
        sign_in seller_user

        expect(controller.after_sign_in_path_for(seller_user)).to eq(products_path)
      end
    end

    context "when user is a buyer" do
      it "redirects to the shopping cart index path" do
        buyer_user = create(:user, role: "buyer")
        sign_in buyer_user

        expect(controller.after_sign_in_path_for(buyer_user)).to eq(shopping_cart_index_path)
      end
    end
  end
end
