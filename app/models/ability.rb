# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.role? :admin
    can [:read, :create, :update, :destroy], Product, user_id: user.id if user.role? :seller
    can :destroy, CartItem, user_id: user.id if user.role? :buyer
  end
end

