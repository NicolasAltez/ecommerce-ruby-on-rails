class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ROLES = %i[admin seller buyer]

  def role?(role)
    self.role.to_sym == role.to_sym
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

        
end
