$(document).on 'turbolinks:load', ->
  # Unsubscribe from all conversation channels
  App.cable.subscriptions.subscriptions.filter((sub) ->
    JSON.parse(sub.identifier).channel == 'ConversationMessagesChannel'
  ).forEach (sub) ->
    sub.unsubscribe()

  return unless $('.messages-block').length > 0
  channel_id = $('.messages-block').first().attr('id')
  return unless channel_id

  # Subscribe only to the current one if it is present
  sub = App.cable.subscriptions.create { channel: "ConversationMessagesChannel", id: channel_id},
    received: (data) ->
      console.log(data)
      if data.message
        @appendMessage(data.message)
        $.ajax(
          url: "#{location.pathname}/read",
          method: 'PATCH'
        )
      else if data.update
        @updateReadStatus(data.update)

    appendMessage: (message) ->
      $('.messages-block').append(message)
      $('.messages-block').scrollTop($('.messages-block')[0].scrollHeight)

    updateReadStatus: (messages) ->
      messages.forEach (msg) ->
        $("#message-#{msg} > .unread").removeClass('unread')
