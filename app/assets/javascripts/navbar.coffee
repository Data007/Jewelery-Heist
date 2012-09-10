window.initDropdown = () ->
  $('.nav .dropdown-toggle').click ->
    if $(this).hasClass('hide-dropdown')
      $(this).parent().find('ul').hide()
      $(this)
        .addClass('show-dropdown')
        .removeClass('hide-dropdown')
    else
      $(this).parent().find('ul').show()
      $(this)
        .removeClass('show-dropdown')
        .addClass('hide-dropdown')

  $('.nav .dropdown ul').hide()

jQuery ($) ->
  initDropdown()
