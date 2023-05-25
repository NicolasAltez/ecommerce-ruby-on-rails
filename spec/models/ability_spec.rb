require 'rails_helper'
require "cancan/matchers"


RSpec.describe Ability, type: :model do
    let(:admin) { create(:user, role: :admin) }
    let(:seller) { create(:user, role: :seller) }
    let(:buyer) { create(:user, role: :buyer) }
    let(:ability_admin) { Ability.new(admin) }
    let(:ability_seller) { Ability.new(seller) }
    let(:ability_buyer) { Ability.new(buyer) }
  
    describe "admin abilities" do
      it "can manage users" do
        expect(ability_admin).to be_able_to(:manage, User)
      end
  
      it "cannot read products" do
        expect(ability_admin).not_to be_able_to(:read, Product)
      end 
    end
  
    describe "seller abilities" do
      let(:product) { create(:product, user: seller) }
  
      it "can manage own Product" do
        expect(ability_seller).to be_able_to(:manage, product)
      end
  
      it "cannot manage users" do
        expect(ability_seller).not_to be_able_to(:manage, User)
      end
    end
  
    describe 'buyer abilities' do
      let(:order) { create(:order, user: buyer) }
      let(:product) { create(:product) }
  
      it 'can read and create Order' do
        expect(ability_buyer).to be_able_to(:read, Order)
        expect(ability_buyer).to be_able_to(:create, Order)
      end
  
      it 'can access order_history and perform cart actions' do
        expect(ability_buyer).to be_able_to(:order_history, Order)
        expect(ability_buyer).to be_able_to(:add_to_cart, Product)
        expect(ability_buyer).to be_able_to(:remove_from_cart, Product)
        expect(ability_buyer).to be_able_to(:remove_all_from_cart, Product)
        expect(ability_buyer).to be_able_to(:cart, Product)
      end
  
      it 'cannot update or destroy Order' do
        expect(ability_buyer).not_to be_able_to(:update, Order)
        expect(ability_buyer).not_to be_able_to(:destroy, Order)
      end
  
      it 'cannot manage User or Product' do
        expect(ability_buyer).not_to be_able_to(:manage, User)
        expect(ability_buyer).not_to be_able_to(:manage, Product)
      end
    end
  end
  