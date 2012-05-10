# Depends on: jQuery, LocatorGenerator

###

  Usage example:

  Click button first time
    + state: recording
    + enable Node::Actions
    + look for input and record it
    + if more than one input within same form
      try to scope it (Node::Finders)

  Click button second time
    + state: confirming
    + enable Node::Matchers
    + clicking an element will test for
      the existence of the selector
    + text selection will test for the
      content

  Click button third time
    + state: printing
    + background script copys all strings
      to clipboard

  Click button fourth time
    + state: off
    + full reset

###

class Capycorder

  # Existing states: recording, confirming, printing, off
  state: 'off'
  # TODO: can we get this from coffeescript? classes have
  #       a `name` property...
  namespace: 'capycorder'

  constructor: ->
    @locator = new LocatorGenerator

  # TODO: rename to something less chrome-relevant?
  setTabURL: (url) ->
    @tabURL = url

  # TODO: use an existing statemachine implementation?
  # TODO: what happens if for some reason a state is skipped?
  switchState: (state) ->
    switch state
      when 'recording'
        @_attachRecordingEvents()
      when 'confirming'
        @_detachRecordingEvents()
        @_attachConfirmingEvents()
      when 'printing'
        @_detachConfirmingEvents()
        # TODO: Move this to the background page
        Clipboard.copy @getCapybaraMethods()
      when 'off'
        @reset()
    @state = state

  reset: ->

  bind: (event, callback) ->
    $(document).bind [event, @namespace].join('.'), callback

  trigger: (event, data) ->
    $(document).trigger [event, @namespace].join('.'), [data]

  #

  _attachRecordingEvents: ->
    $('input[type=file]').on 'change', (e) => @attachFile $(e.currentTarget)
    # calls #uncheck if not checked:
    $('input[type=checkbox]').on 'change', (e) => @check $(e.currentTarget)
    $('input[type=radio]').on 'click', (e) => @choose $(e.currentTarget)
    $([
      'input[type=submit]'
      'input[type=reset]'
      'input[type=button]'
      'button'
    ].join(',')).on 'click', (e) => @clickButton $(e.currentTarget)
    $('a').on 'click', (e) => @clickLink $(e.currentTarget)
    $([
      'input[type=text]'
      'input[type=password]'
      'input[type=email]'
      'input[type=search]'
      'textarea'
    ].join(',')).on 'keyup', (e) => @fillIn $(e.currentTarget)
    $('select').on 'change', (e) => @select $(e.currentTarget)


  _detachRecordingEvents: ->

  _attachConfirmingEvents: ->
    $(document).on 'mouseup', (e) => @hasSelector $(e.currentTarget)

  _detachConfirmingEvents: ->


  # ----------------------------------------------------------------------------

  # TODO: Move this into it's own class
  # TODO: Remove some of the duplication in the handlers
  # TODO: Either rename the scoping-related parameters or make them more
  #       universial -- depending on what the parent class does
  # TODO: Move the storage of captured actions etc. into the background
  #       page, otherwise the array will be purged e.g. on form submit

  # Node::Actions

  _capturedActions: []
  _captureAction: (name, locator, options = {}) ->
    @_capturedActions.push
      name: name, locator: locator, options: options

  _defaultInputLocatorMethods: ['name', 'id', 'label']

  _formScope: ($el) ->
    if ($form = $el.parents('form')).length
      @locator.generate $form, ['id']
    else
      null
  #

  # input[type="file"]
  attachFile: ($el) =>
    locator  = @locator.generate $el, @_defaultInputLocatorMethods
    @_captureAction 'attachFile', locator, { file: $el.val(), scope: @_formScope($el) }

  # input[type="checkbox"]
  check: ($el) =>
    if $el.is ':checked'
      locator  = @locator.generate $el, @_defaultInputLocatorMethods
      @_captureAction 'check', locator, scope: @_formScope($el)
    else
      @uncheck $el

  # input[type="checkbox"]
  uncheck: ($el) =>
    locator = @locator.generate $el, @_defaultInputLocatorMethods
    @_captureAction 'uncheck', locator, scope: @_formScope($el)

  # input[type="radio"]
  choose: ($el) =>
    locator = @locator.generate $el, 'label id name'.split(' ')
    @_captureAction 'choose', locator, scope: @_formScope($el)

  # input[type="submit"]
  # input[type="button"]
  # input[type="reset"]
  # button
  # ... ?
  clickButton: ($el) =>
    locator = @locator.generate $el, 'id text value'.split(' ')
    @_captureAction 'clickButton', locator, scope: @_formScope($el)

  # textarea
  # input[type="text"]
  # input[type="password"]
  # input[type="email"]
  # input[type="search"]
  # ... ?
  fillIn: ($el) =>
    locator  = @locator.generate $el, @_defaultInputLocatorMethods
    previous = _.last(@_capturedActions)
    if previous && previous.name == 'fillIn' && previous.locator == locator
      # update value
      previous.options.with = $el.val()
    else
      @_captureAction 'fillIn', locator, { with: $el.val(), scope: @_formScope($el) }

  # select
  # - we don't support #unselect for now
  select: ($el) =>
    locator = @locator.generate $el, @_defaultInputLocatorMethods
    @_captureAction 'select', $el.val(), { from: locator, scope: @_formScope($el) }

  # a
  clickLink: ($el) =>
    locator = @locator.generate $el, 'id text imgAlt'.split(' ')
    @_captureAction 'clickLink', locator, scope: @_formScope($el)


  # ----------------------------------------------------------------------------

  # Node::Matchers

  hasSelector: ($el) ->
    # mouseup -> if text range selected,
    # use #hasContent
    # TODO: implement SelectorGenerator class
    # TODO: FUTURE: implement XPathGenerator class
    # selector = @selector.generate($el)
    console.log 'has selector...'

  hasContent: ($el) ->
    console.log 'has content: '


  # ----------------------------------------------------------------------------

  # Node::Finders

  withinForm: ($elements) ->
    # currently part of the


  # ----------------------------------------------------------------------------

  # TODO: move this into capybara code generator class
  # convert to capybara strings
  # TODO: do we need the `page.`?
  TEMPLATES =
    attachFile:  (a) -> "page.attach_file('#{a.locator}', '#{a.options.file}')"
    check:       (a) -> "page.check('#{a.locator}')"
    uncheck:     (a) -> "page.uncheck('#{a.locator}')"
    choose:      (a) -> "page.choose('#{a.locator}')"
    clickButton: (a) -> "page.click_button('#{a.locator}')"
    fillIn:      (a) -> "page.fill_in('#{a.locator}', :with => '#{a.options.with}')"
    select:      (a) -> "page.select('#{a.locator}', :from => '#{a.options.from}')"
    clickLink:   (a) -> "page.click_link('#{a.locator}')"
    withinForm:  (s) -> ["page.within_form('#{s}') do", "end"]
    visitPath:   (p) -> "page.visit('#{p}')"
    it:              -> ["it 'DOES SOMETHING' do", "end"]

  # TODO: this should go into a helper of some kind
  #       maybe use a proper external lib even?
  _parseURL: (url) ->
    a = document.createElement('a')
    a.href = url
    a

  # TODO: this should become a lot more flexibe and
  #       perferably deal with a tree-like structure
  getCapybaraMethods: ->
    [strings, indent] = [[], '  ']

    strings.push TEMPLATES.it()[0]

    path = @_parseURL(@tabURL).pathname
    strings.push indent + TEMPLATES.visitPath(path)

    for action in @_capturedActions
      string = indent
      if action.options.scope
        if scope && scope != action.options.scope
          strings.push indent + TEMPLATES.withinForm(scope)[1]
          scope = null
        unless scope
          scope = action.options.scope
          strings.push indent + TEMPLATES.withinForm(action.options.scope)[0]
        string += indent

      string += TEMPLATES[action.name](action)
      strings.push string

    if scope then strings.push(indent + TEMPLATES.withinForm(scope)[1])

    strings.push TEMPLATES.it()[1]

    strings.join('\n')


window['Capycorder'] = Capycorder
