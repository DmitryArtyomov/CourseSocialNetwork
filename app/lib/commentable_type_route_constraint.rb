class CommentableTypeRouteConstraint
  def matches?(request)
    Comment.valid_commentable_type?(request[:commentable_type])
  end
end
