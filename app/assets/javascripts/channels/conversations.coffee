$(document).on 'turbolinks:load', ->
  # Subscribe to conversations channel if not subscribed and user is logged in
  return if App.cable.conversations_channel
  return unless $('#messages_menu').data()

  App.sound = new Audio('/sounds/message.mp3');

  App.cable.conversations_channel = App.cable.subscriptions.create { channel: "ConversationsChannel" },

    received: (data) ->
      @updateConversationBlockInfo(data)
      @calculateMenuItemCount(data)
      @playSound(data)

    disconnected: ->
      if $('#messages_menu').data()
        App.cable.connect()

    conversationCreateHTML: (data) ->
      $('.no-conversations').remove()
      html = "
        <div class='mini-conversation-block mt-0' id='conversation-#{data.conversation_id}'>
          <a href='/#{ $('#messages_menu').data().myProfileId }/conversations/#{data.conversation_id}'>
            <div class='row vert-align'>
              <div class='col-xs-3 mini-avatar-col'>
                <div class='mini-avatar' style='background-image: url(#{data.conversation_avatar});'></div>
              </div>
              <div class='col-xs-9 mini-text-col'>
                <div class='last-message-time'>#{moment(data.date).format('HH:mm')}</div>
                <div class='conversation-name'>#{data.conversation_name}</div>
                <div class='unread-count'>1</div>
                <div class='last-message-text'>#{@messageOwner(data)}: #{data.text}</div>
              </div>
            </div>
          </a>
        </div>
      "
      $('.conversations-list').prepend(html)

    messageOwner: (data) ->
      if @isSender(data) then 'You' else data.sender

    isSender: (data) ->
      profileID = $('#messages_menu').data().myProfileId
      return `data.sender_id == profileID`

    updateConversationBlockInfo: (updateData) ->
      conversation = $("#conversation-#{updateData.conversation_id}")
      # If there is such conversation block - update it. Otherwise if we are on conversations page add new block
      if conversation.length
        conversation.find('.last-message-time').text(moment(updateData.date).format('HH:mm'))
        conversation.find('.last-message-text').text("#{@messageOwner(updateData)}: #{updateData.text}")
        conversation.prependTo('.conversations-list')
      else if $('.conversations-list').length
        @conversationCreateHTML(updateData)
      @increaseConversationUnreadCount(conversation, updateData)

    increaseConversationUnreadCount: (conversation, updateData) ->
      # Do not increase if we are on that conversation page, or we are the sender
      return if $('.messages-block').attr('id') == "#{updateData.conversation_id}" || @isSender(updateData)
      count = parseInt(conversation.find('.unread-count').text() || 0)
      conversation.find('.unread-count').text("#{count + 1}")

    calculateMenuItemCount: (updateData) ->
      # Do not increase if we are on that conversation page, or we are the sender
      return if $('.messages-block').attr('id') == "#{updateData.conversation_id}" || @isSender(updateData)
      menu_item = $('#messages_menu')
      ids = menu_item.data().ids
      ids.push(updateData.conversation_id)
      ids = `[...new Set(ids)]`
      menu_item.data().ids = ids
      menu_item.find('.badge').text("#{ids.length}")

    playSound: (updateData) ->
      # Do not play if we are on that conversation page, or we are the sender
      return if $('.messages-block').attr('id') == "#{updateData.conversation_id}" || @isSender(updateData)
      App.sound.play()
