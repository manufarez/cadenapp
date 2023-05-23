class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participations
  has_many :cadenas, through: :participations
  has_one_attached :avatar
  validates :sex, presence: true, on: :update
  validates :dob, presence: true, on: :update
  validates :phone, presence: true, on: :update
  validates :identification_type, presence: true, on: :update
  validates :identification_number, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :zip, presence: true, on: :update
  validates :city, presence: true, on: :update
  validates :accepts_terms, acceptance: true, on: :update

  def cadenas_count
    self.cadenas.count
  end

  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
