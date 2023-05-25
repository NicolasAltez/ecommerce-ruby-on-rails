class ShoppingCartController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @products = Product.all
    end
  
    def add_to_cart
        product = Product.find(params[:id])
        quantity = params[:quantity].to_i
    
        session[:cart] = {} unless session[:cart].is_a?(Hash)
        session[:cart][product.id] ||= 0
        session[:cart][product.id] += quantity
    
        redirect_to shopping_cart_path
    end
  
    def remove_from_cart
        product = Product.find(params[:id])
        quantity = params[:quantity].to_i
        session[:cart][product.id.to_s] -= quantity
        session[:cart].delete(product.id.to_s) if session[:cart][product.id.to_s] <= 0
    
        redirect_to shopping_cart_path
      end

      def remove_all_from_cart
        product = Product.find(params[:id])
        session[:cart].delete(product.id.to_s)
    
        redirect_to shopping_cart_path
      end
  
      def cart
        product_ids = session[:cart]&.select { |_, quantity| quantity.present? }&.keys || []
        @products = Product.where(id: product_ids)
        @total_price = @products.sum { |product| product.price * session[:cart][product.id.to_s].to_i }
      end
      
      
  
      def generate_order
        order = current_user.orders.build(order_date: Time.now)
        
        session[:cart].each do |product_id, quantity|
          product = Product.find(product_id)
          order.order_items.build(product: product, quantity: quantity, subtotal: product.price * quantity.to_i)
        end
      
        order.calculate_total
        order.save
      
        session.delete(:cart)
      
        redirect_to order_path(order), notice: 'Order generated successfully.'
      end
      
  
    def order_history
      @orders = current_user.orders
    end
  
    def order_details
      @order = current_user.orders.find(params[:id])
    end
  end
  