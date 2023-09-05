class Cadena < ApplicationRecord
  has_many :participations, dependent: :nullify
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participations
  has_many :installments, dependent: :destroy
  before_save :set_status, :set_saving_goal
  enum status: {
         pending: 'pending',
         complete: 'complete',
         approval_requested: 'approval_requested',
         started: 'started',
         stopped: 'stopped',
         over: 'over',
         archived: 'archived'
       },
       _default: 'pending'
  enum periodicity: { bimonthly: 'bimonthly', monthly: 'monthly' }, _default: 'monthly'

  def admin
    participations.find_by(is_admin: true)&.user
  end

  def missing_participants
    return 0 unless installments.any?

    desired_installments - participations.count
  end

  def set_saving_goal
    return 0 unless installments.any? && installment_value

    self.saving_goal = desired_installments * installment_value
  end

  def set_status
    self.status = if missing_participants.positive?
                    "pending"
                  elsif missing_participants.zero? && !approval_requested && !positions_assigned
                    "complete"
                  elsif missing_participants.zero? && approval_requested && !positions_assigned
                    "approval_requested"
                  elsif missing_participants.zero? && approval_requested && positions_assigned
                    "started"
                  end
  end

  def status_color
    status_colors = {
      'complete' => 'text-primary_blue border-blue-600',
      'pending' => 'text-pinky border-pinky',
      'approval_requested' => 'text-mayo border-mayo',
      'started' => 'text-ciel border-ciel',
      'stopped' => 'text-red-500 border-red-500'
    }

    status_colors[status] || ''
  end
end
