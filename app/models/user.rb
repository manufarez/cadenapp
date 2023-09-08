class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participants, dependent: :nullify
  has_many :cadenas, through: :participants
  has_many :made_payments, dependent: :nullify
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
  delegate :count, to: :cadenas, prefix: true

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def profile_complete?
    required_attributes = %i[phone dob sex address city zip identification_number identification_type accepts_terms]
    required_attributes.all? { |attribute| self[attribute].present? } && avatar.attached?
  end

  def member_of?(cadena)
    cadenas.include?(cadena)
  end

  def participant(cadena)
    participants.find_by(cadena: cadena, user: self)
  end

  def admin_of?(cadena)
    participant = participants.find_by(cadena: cadena, is_admin: true)
    !participant.nil?
  end

  def age
    if dob
      age = Time.zone.today.year - dob.year
      age -= 1 if Time.zone.today < dob + age.years

      age
    else
      'Missing DOB'
    end
  end

  def made_payments
    Payment.where(user: self)
  end
end
