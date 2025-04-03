class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Add any data you want to display on the dashboard
    # For example:
    # @recent_activities = current_user.activities.recent
    # @notifications = current_user.notifications.unread
  end
end
