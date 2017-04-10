$(document).on 'turbolinks:load', ->
  if $('#user_date_of_birth').length > 0
    $('#user_date_of_birth').datetimepicker
      format: 'DD/MM/YYYY'
      minDate: '01/01/1900'
      maxDate: Date.now()
      viewMode: 'decades'
      allowInputToggle: true
      useCurrent: false
    $('#user_date_of_birth').data('DateTimePicker').date moment.utc($('#user_date_of_birth').attr('value').slice(0, -13))
