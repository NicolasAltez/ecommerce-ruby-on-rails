class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  def calculate_total
    self.order_total = order_items.sum(:subtotal)
  end
end
