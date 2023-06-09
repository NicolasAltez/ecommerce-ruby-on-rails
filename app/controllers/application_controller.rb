class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if current_user.role?(:admin)
      admin_user_management_index_path
    elsif current_user.role?(:seller)
      products_path
    elsif current_user.role?(:buyer)
      shopping_cart_index_path
    else
      root_path
    end
  end
end
