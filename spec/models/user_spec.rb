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
end

RSpec.describe Order, type: :model do
  it "belongs to a user" do
    should belong_to(:user)
  end

  it "has many order items" do
    should have_many(:order_items)
  end

  it "has many products through order items" do 
    should have_many(:products).through(:order_items)
  end
end
