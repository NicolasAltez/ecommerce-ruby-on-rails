class ProductsController < ApplicationController

    def index
        @products = Product.all
        @current_user = current_user
    end

    def new
        @products
    end

    def create 
        @product = Product.new(products_params)
        @product.user_id = current_user.id
        @product.save ? (notice : 'Product was successfully created.') : (alert : 'Something went wrong.')
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        @product.user_id = current_user.id
        @product.update(product_params) ? (notice: 'Product was successfully updated.') : (alert : 'Something went wrong.')
    end

    def destroy
        @product = Product.find(params[:id])
        @product.user_id = current_user.id
        @product.destroy ? (notice: 'Product was delete.') : (alert : 'Something went wrong.')
    end

    private
    
    def products_params
        params.require(:product).permit(:name, :description, :price)
    end
end
