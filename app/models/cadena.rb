class Cadena < ApplicationRecord
  has_many :participations
  has_many :invitations
  has_many :users, through: :participations

  def approved_participants
    self.participations.count
  end

  def admin
    self.participations.where(is_admin: true).first.user
  end

  def missing_participants
    if self.periodicity == "mensual"
      self.installments - self.approved_participants
    elsif self.periodicity == "quincenal"
      self.installments / 2 - self.approved_participants
    end
  end

  def status
    if self.approved_participants == self.installments
      "Full"
    else
      "#{self.missing_participants.to_s} en espera"
    end
  end
end
