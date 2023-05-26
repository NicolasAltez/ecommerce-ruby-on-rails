require 'rails_helper'

RSpec.describe User, type: :model do
  it "validates fields presence" do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
    should validate_presence_of(:password)
    should validate_presence_of(:role)
  end

  it "has many orders" do
    should have_many(:orders)
  end

  it "has many products through orders" do
    should have_many(:products).through(:orders)
  end

  it "creates a valid user" do
    user = create(:user)
    expect(user).to be_valid
  end
  
  describe "#role?" do
    let(:seller_user) { create(:user, role: 'seller') }
    let(:admin_user) { create(:user, role: 'admin') }
    let(:buyer_user) { create(:user, role: 'buyer') }

    it "returns true if the user has the specified role" do
      expect(seller_user.role?(:seller)).to be true
      expect(admin_user.role?(:admin)).to be true
      expect(buyer_user.role?(:buyer)).to be true
    end

    it "returns false if the user does not have the specified role" do
      expect(seller_user.role?(:admin)).to be false
      expect(admin_user.role?(:seller)).to be false
      expect(buyer_user.role?(:admin)).to be false
    end
  end
end
