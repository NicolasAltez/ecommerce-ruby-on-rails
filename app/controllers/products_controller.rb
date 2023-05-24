class ProductsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def index
        @products = Product.all
        @current_user = current_user
    end

    def new
        @products
    end

    def create
        @product = Product.new(product_params)
        @product.user_id = current_user.id
    
        if @product.save
          redirect_to products_path, notice: 'Product was successfully created.'
        else
          render :new
        end
      end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
    
        if @product.update(product_params)
          redirect_to products_path, notice: 'Product was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @product = Product.find(params[:id])
        @product.destroy
    
        redirect_to products_path, notice: 'Product was successfully destroyed.'
      end

    private
    
    def product_params
        params.require(:product).permit(:name, :description, :price)
    end
end
