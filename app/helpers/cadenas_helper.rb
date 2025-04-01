module CadenasHelper
  def state_color(state)
    state_colors = {
      "complete" => "text-ciel border-ciel",
      "pending" => "text-pinky border-pinky",
      "participants_approval" => "text-mayo border-mayo",
      "started" => "text-primary-blue border-blue-600",
      "stopped" => "text-red-500 border-red-500"
    }
    state_colors[state] || ""
  end
end
