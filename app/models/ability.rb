# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User if user.role? :admin
    can [:read, :create, :update, :destroy], Product, user_id: user.id if user.role? :seller
    if user.role? :buyer
      can [:read, :create], Order, user_id: user.id 
      can :order_history, Order
      can :add_to_cart, Product
      can :remove_from_cart, Product
      can :remove_all_from_cart, Product
      can :cart, Product
    end
  end
end

