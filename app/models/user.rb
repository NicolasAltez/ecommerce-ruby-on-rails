class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :products

  ROLES = %i[admin seller buyer]

  def role?(role)
    self.role.to_sym == role.to_sym
  end

 

        
end
