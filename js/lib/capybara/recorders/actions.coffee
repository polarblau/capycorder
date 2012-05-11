window.Capybara    ||= {}
Capybara.Recorders ||= {}

class Capybara.Recorders.Actions

  actions: []
  namespace: 'actionrecorder'

  events:
    'change input[type=file]'    : 'attachFile'
    'change input[type=checkbox]': 'check'
    'click input[type=radio]'    : 'choose'
    'click input[type=submit]'   : 'clickButton'
    'click input[type=reset]'    : 'clickButton'
    'click input[type=button]'   : 'clickButton'
    'click button'               : 'clickButton'
    'click a'                    : 'clickLink'
    'keyup input[type=text]'     : 'fillIn'
    'keyup input[type=password]' : 'fillIn'
    'keyup input[type=email]'    : 'fillIn'
    'keyup input[type=search]'   : 'fillIn'
    'keyup textarea'             : 'fillIn'
    'change select'              : 'select'


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
  # TODO: Remove some of the duplication
  #       Defining $el through the event is forced by the delegation

  attachFile: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['name', 'id', 'label']
    @findScopeAndCapture 'attachFile', $el, locator, file: $el.val()

  check: (e) =>
    $el = $(e.target)
    if $el.is ':checked'
      locator = $el.getLocator ['name', 'id', 'label']
      @findScopeAndCapture 'check', $el, locator
    else
      @uncheck $el

  uncheck: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['name', 'id', 'label']
    @findScopeAndCapture 'uncheck', $el, locator

  choose: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['label', 'id', 'name']
    @findScopeAndCapture 'choose', $el, locator

  clickButton: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['id', 'text', 'value']
    @findScopeAndCapture 'clickButton', $el, locator

  clickLink: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['id', 'text', 'imgAlt']
    @findScopeAndCapture 'clickLink', $el, locator

  fillIn: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['name', 'id', 'label']
    @findScopeAndCapture 'fillIn', $el, locator, with: $el.val()

  select: (e) =>
    $el = $(e.target)
    locator = $el.getLocator ['name', 'id', 'label']
    @findScopeAndCapture 'select', $el, $el.val(), from: locator

  # HELPERS

  findScopeAndCapture: (name, $el, locator, options) ->
    @capture name, locator, @_formScope($el), options

  capture: (name, locator, scope, options = {}) ->
    # TODO: debounce:
    action =
      type   : 'action',
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
      $form.getLocator ['id']
    else
      null

  _nsevent: (event) ->
    [event, @namespace].join('.')

  _attachEvents: ->
    for target, method of @events
      [event, selector] = target.split(' ')
      @$scope.delegate selector, event, @[method]

  _detachEvents: ->
    @$scope.undelegate ".#{@namespace}"
