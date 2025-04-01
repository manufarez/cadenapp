class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :participants, dependent: :destroy
  has_many :cadenas, through: :participants
  has_many :made_payments, class_name: "Payment", dependent: :destroy
  has_many :received_payments, through: :participants, source: :received_payments, dependent: :destroy

  has_one_attached :avatar
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :avatar, presence: {message: "tiene que ser vinculado al perfil"}, on: :update
  validates :avatar, blob: {content_type: ["image/png", "image/jpg", "image/jpeg"], size_range: 1..(2.megabytes)}
  validates :sex, presence: true, on: :update
  validates :dob, presence: true, on: :update
  validates :phone, presence: true, on: :update
  validates :identification_type, presence: true, on: :update
  validates :identification_number, presence: true, on: :update
  validates :address, presence: true, on: :update
  # validates :zip, presence: true, on: :update
  validates :city, presence: true, on: :update
  validates :accepts_terms, acceptance: true, on: :update
  delegate :count, to: :cadenas, prefix: true

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def profile_complete?
    # don't forget to add #zip
    required_attributes = %i[phone dob sex address city identification_number identification_type accepts_terms]
    required_attributes.all? { |attribute| self[attribute].present? } && avatar.attached?
  end

  def member_of?(cadena)
    cadenas.include?(cadena)
  end

  def participant(cadena)
    participants.find_by(cadena: cadena, user: self)
  end

  def admin_of?(cadena)
    return false if cadena.admin.blank?

    self == cadena.admin.user
  end

  def age
    if dob
      age = Time.zone.today.year - dob.year
      age -= 1 if Time.zone.today < dob + age.years

      age
    else
      "Missing DOB"
    end
  end
end
