$(document).on 'turbolinks:load', ->
  $('.navbar-brand').hover (->
    $(this).fadeOut(150, ->
      $(this).text('StayInTouch')
      $(this).fadeIn(150)
    )), ->
    $(this).fadeOut(150, ->
      $(this).text('SiT')
      $(this).fadeIn(150)
    )
