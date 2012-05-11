window.Capybara    ||= {}
Capybara.Recorders ||= {}

class Capybara.Recorders.Matchers

  matchers: []
  namespace: 'matcherrecorder'

  # ----------------------------------------------------------------------------
  # INSTANCE METHODS

  constructor: (options) ->
    @$scope = $(options.scope || document)
    @afterCaptureCallback = options.afterCapture ? ->

  start: ->
    @_attachEvents()

  stop: ->
    @_detachEvents()


  # ----------------------------------------------------------------------------
  # EVENTHANDLERS

  shouldHaveSelector: ($el) ->
    selection = window.getSelection().toString()
    if selection.length
      @shouldHaveContent($el, selection)
    else
      selector = $el.selector()
      @capture 'shouldHaveSelector', selector

  shouldHaveContent: ($el) ->
    content = window.getSelection().toString()
    selector = $el.selector()
    @capture 'shouldHaveContent', selector, null, content: content


  # HELPERS

  capture: (name, selector, scope = null, options = {}) ->
    action =
      type    : @namespace,
      name    : name,
      selector: selector,
      scope   : scope
      options : options

    @actions.push action
    @afterCaptureCallback action

  # ----------------------------------------------------------------------------
  # "PRIVATE"

  _nsevent: (event) ->
    [event, @namespace].join('.')

  _attachEvents: ->
    $(document).on @_nsevent('mouseup'), (e) =>
      @shouldHaveSelector $(e.target)

  _detachEvents: ->
    $(document).off @_nsevent('mouseup')

