class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:toggle]
  before_action :likeable_exists!

  def fetch
    @likes = Like.where(shared_params).includes(profile: :avatar)
    render action: 'fetch', layout: false if request.xhr?
    # respond_with decorate likes_enriched
  end

  def toggle
    @like = Like.find_by(like_params)
    @like = @like.present? ? @like.destroy : Like.create(like_params)
    @likeable.reload
    respond_to do |format|
      format.js { }
    end
  end

  # Ensure that likeable model exists
  private def likeable_exists!
    @likeable = shared_params[:likeable_type].safe_constantize&.find(shared_params[:likeable_id])
    raise ActiveRecord::RecordNotFound if @likeable.blank?
  end

  private def like_params
    @like_params ||= shared_params.merge(profile_params)
  end

  private def profile_params
    @profile_params ||= {
      profile_id: current_profile.id
    }
  end

  private def shared_params
    @shared_params ||= {
      likeable_id:   params.require(:likeable_id),
      likeable_type: params.require(:likeable_type).to_s.camelize
    }
  end
end
