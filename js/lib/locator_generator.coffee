# Depends on: jQuery

# Class: LocatorGenerator
#
# Generate a locator usable with Capybara
# for a jQuery element
#
class LocatorGenerator

  # Try's all locator methods (in order) specified in `methods`
  # and returns the first valid result (not null).
  #
  # @param {Object} $el The jQuery element
  # @param {Array} methods Sorted list of used identifiers
  # @returns {String} Locator string
  #
  # @example:
  #   locatorGenerator = new LocatorGenerator
  #   $el = $('<button id="foo">Bar</button>)
  #   locatorGenerator.generate $el, ['value', 'text', 'id']
  #     => "Bar"
  #
  generate: ($el, methods = ['id']) ->
    _.compact(_.map(methods, (method) => @[method]($el)))[0]

  #

  id: ($el) ->
    if (id = $el.attr('id'))? then id else null

  name: ($el) ->
    if (name = $el.attr('name'))? then name else null

  label: ($el) ->
    if ($label = @_findLabelForInput($el))?
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

  # returns alt for first included image
  imgAlt: ($el) ->
    $img = $el.find('img:first')
    if $img.length
      $img.attr('alt')
    else
      null

  #

  _findLabelForInput: ($input) ->
    $label = $("label[for=#{$input.attr('id')}]")
    unless $label.length
      $label = $input.closest 'label'
    if $label.length then $label else null


window['LocatorGenerator'] = LocatorGenerator
