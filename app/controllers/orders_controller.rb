class OrdersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

      def index
        @orders = current_user.orders.includes(:products)
      end
    
      def create
        order = current_user.orders.build
        product_ids = session[:cart]&.keys
        products = Product.where(id: product_ids)
      
        if products.empty?
          redirect_to shopping_cart_path
          return
        end
      
        order.products << products
        order.order_total = products.sum { |product| product.price * session[:cart][product.id.to_s].to_i }
      
        if order.save
          session[:cart] = {}
          redirect_to order_history_path
        else
          redirect_to shopping_cart_path, alert: 'Failed to place the order.'
        end
      end
      
      def order_history
        @orders = current_user.orders.includes(products: :order_items)      
        render :order_history
      end
      
end
