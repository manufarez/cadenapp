module CadenasHelper
  def status_color(status)
    status_colors = {
      'complete' => 'text-ciel border-ciel',
      'pending' => 'text-pinky border-pinky',
      'participants_approval' => 'text-mayo border-mayo',
      'started' => 'text-primary_blue border-blue-600',
      'stopped' => 'text-red-500 border-red-500'
    }
    status_colors[status] || ''
  end
end
