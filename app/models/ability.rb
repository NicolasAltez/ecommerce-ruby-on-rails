# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.admin?
    can :manage, :all

    return unless user.seller?  # additional permissions for sellers
    can [:read, :create, :update, :destroy], Product, user_id: user.id

    return unless user.buyer?  # additional permissions for buyers
    can :destroy, CartItem, user_id: user.id
  end
end

