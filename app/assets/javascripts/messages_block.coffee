$(document).on 'turbolinks:load', ->
  messages_block = $('.messages-block')
  if messages_block.length > 0
    $(window).resize ->
      windowHeight = $(window).outerHeight()
      offset = messages_block.offset()['top']
      height = Math.max(300, windowHeight - offset - 15 - $('.message-form-block').outerHeight())
      messages_block.css('min-height', height).css('max-height', height)
      messages_block.scrollTop(messages_block[0].scrollHeight)
      conversations_list = $('.conversations-list').css('max-height', Math.max(300, windowHeight - offset - 15))
    $(window).resize()
