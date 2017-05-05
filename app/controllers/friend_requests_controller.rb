class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile

  def index
    authorize! :view_requests, @profile
    @profile = @profile.decorate
    @incoming_count = @profile.incoming_unaccepted_friend_requests.count
    @outgoing_count = @profile.outgoing_unaccepted_friend_requests.count
    case @section = params[:section]
    when 'outgoing'
      @requests = @profile.outgoing_unaccepted_friend_requests.includes(recipient: [ :user, :avatar ])
        .order(updated_at: :desc)
    else
      @requests = @profile.incoming_requests.includes(sender: [ :user, :avatar ])
    end
  end

  def create
    if @friend_request.reverse?
      @friend_request.reverse.update_attribute(:status, :accepted)
    elsif @friend_request.save
      flash[:notice] = "Friend request successfully sent"
    else
      flash[:alert] = "Error sending friend request"
    end
    redirect_to request.referrer
  end

  def cancel
    if @friend_request.destroy
      flash[:notice] = "Friend request was successfully cancelled"
    else
      flash[:alert] = "Error cancelling friend request"
    end
    redirect_to request.referrer
  end

  def destroy
    if @friend_request.sender == current_profile
      former_friend = @friend_request.recipient
      result = @friend_request.reverse!
    else
      former_friend = @friend_request.sender
      result = @friend_request.update_attribute(:status, :declined)
    end

    if result
      flash[:notice] = "Friendship was successfully removed"
    else
      flash[:alert] = "Error removing friendship"
    end
    redirect_to request.referrer
  end

  def accept
    if @friend_request.accepted!
      flash[:notice] = "Friend request was successfully accepted"
    else
      flash[:alert] = "Error accepting friend request"
    end
    redirect_to request.referrer
  end

  def decline
    if @friend_request.declined!
      flash[:notice] = "Friend request was declined"
    else
      flash[:alert] = "Error declining friend request"
    end
    redirect_to request.referrer
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:recipient_id)
  end
end
