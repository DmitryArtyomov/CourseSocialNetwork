$(document).on 'turbolinks:load', ->
  $('#likes-modal').on 'show.bs.modal', (event) ->
    $('.modal-body').load event.relatedTarget.href

  # Fix for 'Back' with turbolinks and modal staying open
  $('#likes-modal').removeClass 'in'
  $('body').removeClass 'modal-open'
  $('.modal-backdrop.fade.in').remove()
  $('#likes-modal .modal-content').empty()
  $('#likes-modal').hide()

$(document).on 'hidden.bs.modal', (e) ->
  $(e.target).removeData 'bs.modal'
