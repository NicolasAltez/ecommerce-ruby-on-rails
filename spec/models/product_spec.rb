require 'rails_helper'

RSpec.describe Product, type: :model do
  it "validates fields presence" do
    should validate_presence_of(:name)
    should validate_presence_of(:description)
    should validate_presence_of(:price)
  end

  it "belongs to a user" do
    should belong_to(:user)
  end

  it "has many order items" do
    should have_many(:order_items)
  end

  it "has many orders through order items" do
    should have_many(:orders).through(:order_items)
  end

end
