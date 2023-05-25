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

  #it "calculates the total order amount correctly" do
   # user = create(:user)
   # order = create(:order, user: user)
   # product1 = create(:product, price: 10)
   # product2 = create(:product, price: 15)
   # order_item1 = create(:order_item, order: order, product: product1)
   # order_item2 = create(:order_item, order: order, product: product2)

    #order.calculate_total

    #expect(order.order_total).to eq(25)
  #end
end
