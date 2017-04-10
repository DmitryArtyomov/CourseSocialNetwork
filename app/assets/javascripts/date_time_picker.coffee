$(document).on 'turbolinks:load', ->
  val_exist = $('#user_date_of_birth').attr('value') != undefined && $('#user_date_of_birth').attr('value').length > 0
  if $('#user_date_of_birth').length > 0
    $('#user_date_of_birth').datetimepicker
      format: 'DD/MM/YYYY'
      minDate: '01/01/1900'
      maxDate: Date.now()
      viewMode: if val_exist then 'days' else 'decades'
      allowInputToggle: true
      useCurrent: false
    if val_exist
      $('#user_date_of_birth').data('DateTimePicker').date moment.utc($('#user_date_of_birth').attr('value').slice(0, -13))
