class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  def calculate_total
    total = order_items.map { |item| item.product.price }.sum
    self.order_total = total
    save
  end
  
end
