class LikeableTypeRouteConstraint
  def matches?(request)
    Like.valid_likeable_type?(request[:likeable_type])
  end
end
