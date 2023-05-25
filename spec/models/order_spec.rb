require 'rails_helper'

RSpec.describe Order, type: :model do
  it "belongs to a user" do
    should belong_to(:user)
  end

  it "has many order_items" do
    should have_many(:order_items)
  end

  it "has many products through order_items" do
    should have_many(:products).through(:order_items)
  end
  
end
