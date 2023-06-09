class Product < ApplicationRecord
    belongs_to :user
    has_many :order_items
    has_many :orders, through: :order_items, dependent: :destroy
    validates :name, :description, :price, presence: true
end
  