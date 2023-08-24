class Cadena < ApplicationRecord
  has_many :participations, dependent: :nullify
  has_many :invitations, dependent: :destroy
  has_many :users, through: :participations
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
    installments - participations.count
  end

  def set_saving_goal
    return unless installments && installment_value

    self.saving_goal = installments * installment_value
  end

  # this is partly wrong because other statuses can  have 0 missing participants
  def set_status
    self.status = if missing_participants.positive?
                    'pending'
                  else
                    'complete'
                  end
  end

  def status_color
    status_colors = {
      'complete' => 'text-primary_blue',
      'pending' => 'text-pinky',
      'approval_requested' => 'text-mayo',
      'started' => 'text-ciel',
      'stopped' => 'text-red-500'
    }

    status_colors[status] || ''
  end
end
