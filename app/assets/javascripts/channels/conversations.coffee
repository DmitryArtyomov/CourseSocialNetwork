$(document).on 'turbolinks:load', ->
  # Subscribe to conversations channel if not subscribed
  return if App.cable.conversations_channel

  App.cable.conversations_channel = App.cable.subscriptions.create { channel: "ConversationsChannel" },
    received: (data) ->
      @updateConversation(data)

    updateConversation: (updateData) ->
      @updateConversationBlockInfo(updateData)
      @calculateMenuItemCount(updateData)

    messageOwner: (data) ->
      if @isSender(data) then 'You' else data.sender

    isSender: (data) ->
      profileID = $('#messages_menu').data().myProfileId
      return `data.sender_id == profileID`

    updateConversationBlockInfo: (updateData) ->
      conversation = $("#conversation-#{updateData.conversation_id}")
      # Skip if there is no such block (if we are on another page)
      return unless conversation.length
      conversation.find('.last-message-time').text(moment(updateData.date).format('HH:mm'))
      conversation.find('.last-message-text').text("#{@messageOwner(updateData)}: #{updateData.text}")
      conversation.prependTo('.conversations-list')
      @increaseConversationUnreadCount(conversation, updateData)

    increaseConversationUnreadCount: (conversation, updateData) ->
      # Do not increase if we are on that conversation page, or we are the sender
      return if $('.messages-block').attr('id') || @isSender(updateData)
      count = parseInt(conversation.find('.unread-count').text() || 0)
      conversation.find('.unread-count').text("#{count + 1}")

    calculateMenuItemCount: (updateData) ->
      menu_item = $('#messages_menu')
      ids = menu_item.data().ids
      ids.push(updateData.conversation_id)
      ids = `[...new Set(ids)]`
      menu_item.data().ids = ids
      menu_item.find('.badge').text("#{ids.length}")
