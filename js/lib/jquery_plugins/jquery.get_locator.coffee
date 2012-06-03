methods =

  id: ($el) ->
    if (id = $el.attr('id'))? then id else null

  name: ($el) ->
    if (name = $el.attr('name'))? then name else null

  label: ($el) ->
    if ($label = helpers.findLabelForInput($el))?
      $.trim($label.text())
    else
      null

  text: ($el) ->
    if (text = $.trim($el.text())).length
      text
    else
      null

  value: ($el) ->
    if (value = $.trim($el.val())).length
      value
    else
      null

  imgAlt: ($el) ->
    $img = $el.find('img:first')
    if $img.length
      $img.attr('alt')
    else
      null

helpers =

  findLabelForInput: ($input) ->
    $label = $("label[for=#{$input.attr('id')}]")
    unless $label.length
      $label = $input.closest 'label'
    if $label.length then $label else null


$.fn.extend
  getLocator: (preferredMethods) ->
    _.compact(
      _.map(preferredMethods, (method) =>
        methods[method](@)
      )
    )[0]
