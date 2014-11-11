class NotificationsController < BaseController

  def index
    if user_signed_in?
      @read_notifications = current_user.notifications
      @unread_notifications = Notification.where("id not in (?)", @read_notifications.map(&:id).push('0'))
      @count = @unread_notifications.count
    end
    respond_to do |format|
      format.js 
    end
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    current_user.notifications << @notification

    respond_to do |format|
      format.json { render json: true }
    end
  end
  
end
