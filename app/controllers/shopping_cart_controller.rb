class ShoppingCartController < ApplicationController
    before_action :authenticate_user!

    def index
      @products = Product.all
    end
  
    def add_to_cart
      authorize! :add_to_cart, Product
      product = Product.find(params[:id])
      quantity = params[:quantity].to_i
    
      session[:cart] ||= {} 
    
      if session[:cart].key?(product.id.to_s)
        session[:cart][product.id.to_s] += quantity
      else
        session[:cart][product.id.to_s] = quantity
      end
    
      redirect_to shopping_cart_path
    end
    
  
    def remove_from_cart
        authorize! :remove_from_cart, Product
        product = Product.find(params[:id])
        quantity = params[:quantity].to_i
        session[:cart][product.id.to_s] -= quantity
        session[:cart].delete(product.id.to_s) if session[:cart][product.id.to_s] <= 0
    
        redirect_to shopping_cart_path
      end

      def remove_all_from_cart
        authorize! :remove_all_from_cart, Product
        product = Product.find(params[:id])
        session[:cart].delete(product.id.to_s)
    
        redirect_to shopping_cart_path
      end
  
      def cart
        authorize! :cart, Product
        product_ids = session[:cart]&.select { |_, quantity| quantity.present? }&.keys || []
        @products = Product.where(id: product_ids)
        @total_price = @products.sum { |product| product.price * session[:cart][product.id.to_s].to_i }
      end

  end
  