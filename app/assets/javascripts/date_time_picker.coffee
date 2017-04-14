$(document).on 'turbolinks:load', ->
  input = $("input[id*='date_of_birth']")
  val_exist = input.attr('value') != undefined && input.attr('value').length > 0
  if input.length > 0
    input.datetimepicker
      format: 'DD/MM/YYYY'
      minDate: '1900-01-01'
      maxDate: Date.now()
      viewMode: if val_exist then 'days' else 'decades'
      allowInputToggle: true
      useCurrent: false
    if val_exist
      input.data('DateTimePicker').date moment.utc(input.attr('value').slice(0, -13))
