class Cadena < ApplicationRecord
  has_many :participations
  has_many :invitations
  has_many :users, through: :participations
  enum status: { pending: "pending", complete: "complete", approval_requested: "approval_requested", started: "started", stopped: "stopped", over: "over", archived: "archived" }, _default: "pending"
  enum periodicity: { bimonthly: "bimonthly", monthly: "monthly" }, _default: "monthly"

  def admin
    participations.find_by(is_admin: true)&.user
  end

  def missing_participants
    if self.periodicity == "monthly"
      self.installments - self.participations.count
    elsif self.periodicity == "bimonthly"
      self.installments / 2 - self.participations.count
    end
  end

  def set_status
    if self.missing_participants > 0
      self.pending!
    elsif self.missing_participants == 0
      self.complete!
    end
  end
end
