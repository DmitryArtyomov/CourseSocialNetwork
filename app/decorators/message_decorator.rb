class MessageDecorator < Draper::Decorator
  delegate_all

  def concurrent?(another)
    return false unless another
    another.sender_id == object.sender_id
  end
end
