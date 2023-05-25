class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :orders
  has_many :products, through: :orders

  validates :name, :email, :password, :role, presence: true
  validates :email, uniqueness: true

  ROLES = %i[admin seller buyer]

  def role?(role)
    self.role.to_sym == role.to_sym
  end
       
end
