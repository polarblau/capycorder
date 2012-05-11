window.Capybara    ||= {}
Capybara.Recorders ||= {}

class Capybara.Recorders.Actions

  actions: []
  namespace: 'actionrecorder'

  events:
    'change input[type=file]'    : @attachFile
    'change input[type=checkbox]': @check
    'click input[type=radio]'    : @choose
    'click input[type=submit]'   : @clickButton
    'click input[type=reset]'    : @clickButton
    'click input[type=button]'   : @clickButton
    'click button'               : @clickButton
    'click a'                    : @clickLink
    'keyup input[type=text]'     : @fillIn
    'keyup input[type=password]' : @fillIn
    'keyup input[type=email]'    : @fillIn
    'keyup input[type=search]'   : @fillIn
    'keyup textarea'             : @fillIn
    'change select'              : @select


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

  attachFile: ($el) ->
    locator = $el.locator ['name', 'id', 'label']
    @findScopeAndCapture 'attachFile', $el, locator, file: $el.val()

  check: ($el) ->
    if $el.is ':checked'
      locator = $el.locator ['name', 'id', 'label']
      @findScopeAndCapture 'check', $el, locator
    else
      @uncheck $el

  uncheck: ($el) ->
    locator = $el.locator ['name', 'id', 'label']
    @findScopeAndCapture 'uncheck', $el, locator

  choose: ($el) ->
    locator = $el.locator ['label', 'id', 'name']
    @findScopeAndCapture 'choose', $el, locator

  clickButton: ($el) ->
    locator = $el.locator ['id', 'text', 'value']
    @findScopeAndCapture 'clickButton', $el, locator

  clickLink: ($el) ->
    locator = $el.locator ['id', 'text', 'imgAlt']
    @findScopeAndCapture 'clickLink', $el, locator

  fillIn: ($el) ->
    locator = $el.locator ['name', 'id', 'label']
    previous = _.last(@actions)
    if previous && previous.name == 'fillIn' && previous.locator == locator
      previous.options.with = $el.val()
    else
      @findScopeAndCapture 'fillIn', $el, locator, width: $el.val()

  select: ($el) ->
    locator = $el.locator ['name', 'id', 'label']
    @findScopeAndCapture 'select', $el, $el.val(), from: locator

  # HELPERS

  findScopeAndCapture: (name, $el, locator, options) ->
    @capture name, @_formScope($el), locator, options

  capture: (name, locator, scope, options = {}) ->
    action =
      type   : @namespace,
      name   : name,
      locator: locator,
      scope  : scope
      options: options

    @actions.push action
    @afterCaptureCallback action

  # ----------------------------------------------------------------------------
  # "PRIVATE"

  _formScope: ($el) ->
    if ($form = $el.parents('form')).length
      $form.locator ['id']
    else
      null

  _nsevent: (event) ->
    [event, @namespace].join('.')

  _attachEvents: ->
    for target, method in @events
      [event, element] = target.split(' ')
      @$scope.delegate element, @_nsevent(event), (e) => method(e)

  _detachEvents: ->
    @$scope.undelegate ".#{@namespace}"
