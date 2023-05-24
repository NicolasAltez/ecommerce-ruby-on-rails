class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if current_user.role?(:admin)
      admin_dashboard_path
    elsif current_user.role?(:seller)
      products_path
    elsif current_user.role?(:buyer)
      buyer_dashboard_path
    else
      root_path
    end
  end
  
  
end
