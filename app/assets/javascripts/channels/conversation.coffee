$(document).on 'turbolinks:load', ->
  # Unsubscribe from all conversation channels
  App.cable.subscriptions.subscriptions.filter((sub) ->
    JSON.parse(sub.identifier).channel == 'ConversationChannel'
  ).forEach (sub) ->
    sub.unsubscribe()

  return unless $('.messages-block').length > 0
  channel_id = $('.messages-block').first().attr('id')
  return unless channel_id

  # Subscribe only to the current one if it is present
  sub = App.cable.subscriptions.create { channel: "ConversationChannel", id: channel_id},
    received: (data) ->
      @appendMessage(data)
      $('.messages-block').scrollTop($('.messages-block')[0].scrollHeight)

    appendMessage: (data) ->
      $(".messages-block").append(data)

# $('.mini-conversation-block').first().find('.last-message-time').text()


# $('.mini-conversation-block').sort(function (a, b) {
#   var contentA =parseInt( $(a).find('.last-message-time').text());
#   var contentB =parseInt( $(b).find('.last-message-time').text());
#   return (contentA < contentB) ? -1 : (contentA > contentB) ? 1 : 0;
# })
