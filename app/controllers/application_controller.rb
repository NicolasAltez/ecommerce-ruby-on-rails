class ApplicationController < ActionController::Base
  
  
    def after_sign_in_path(resource)
      if current_user.admin?
        admin_dashboard_path
      elsif current_user.seller?
        products_path
      else
        buyer_dashboard_path
      end
    end
end
  
