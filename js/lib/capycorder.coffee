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
    @highlighter = new SelectionBox

  # TODO: rename to something less chrome-relevant?
  # TODO: maybe this should even go into the background?
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
        @_enableHighlighting()
      when 'printing'
        @_detachConfirmingEvents()
        # TODO: Move this to the background page
        Clipboard.copy @getCapybaraMethods()
      when 'off'
        @reset()
    @state = state

  reset: ->

  bind: (event, callback) ->
    $(document).on [event, @namespace].join('.'), callback

  trigger: (event, data) ->
    $(document).trigger [event, @namespace].join('.'), [data]

  #

  _enableHighlighting: ->
    $(document).on 'mousemove', (e) =>
      e.preventDefault()
      e.stopPropagation()
      @highlighter.highlight(e.target)


  _attachRecordingEvents: ->
    # TODO: use delegate:
    #       $(document).delegate 'input[type=file]', ['change', @namespace].join('.'), (e) =>
    # TODO:
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
    # TODO: use undelegate
    #       $(document).undelegate ".#{@namespace}"

  _attachConfirmingEvents: ->
    # TODO: use delegate
    $(document).on 'mouseup', (e) => @shouldHaveSelector $(e.target)


  _detachConfirmingEvents: ->
    # TODO: use undelegate
    #       $(document).undelegate ".#{@namespace}"



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

  _confirmedElements: []
  _confirmElement: (name, selector, options = {}) ->
    @_confirmedElements.push
      name: name, selector: selector, options: options


  shouldHaveSelector: ($el) ->
    # TODO: implement SelectorGenerator class
    # TODO: FUTURE: implement XPathGenerator class
    selection = window.getSelection().toString()
    if selection.length
      @shouldHaveContent($el, selection)
    else
      selector = $el.getSelector()
      @_confirmElement 'shouldHaveSelector', selector

  shouldHaveContent: ($el, content) ->
    @_confirmElement 'shouldHaveContent', content


  # ----------------------------------------------------------------------------

  # Node::Finders

  withinForm: ($elements) ->
    # currently part of the


  # ----------------------------------------------------------------------------

  # TODO: move this into capybara code generator class
  # convert to capybara strings
  # TODO: do we need the `page.`?
  TEMPLATES =
    # CAPYBARA actions
    attachFile:  (a) -> "attach_file('#{a.locator}', '#{a.options.file}')"
    check:       (a) -> "check('#{a.locator}')"
    uncheck:     (a) -> "uncheck('#{a.locator}')"
    choose:      (a) -> "choose('#{a.locator}')"
    clickButton: (a) -> "click_button('#{a.locator}')"
    fillIn:      (a) -> "fill_in('#{a.locator}', :with => '#{a.options.with}')"
    select:      (a) -> "select('#{a.locator}', :from => '#{a.options.from}')"
    clickLink:   (a) -> "click_link('#{a.locator}')"
    withinForm:  (s) -> ["within_form('#{s}') do", "end"]
    visitPath:   (p) -> "visit('#{p}')"
    # CAPYBARA confirms
    shouldHaveSelector: (s) -> "page.should have_selector('#{s}')"
    shouldHaveContent:  (c) -> "page.should have_content('#{c}')"
    # RSPEC
    it: -> ["it 'DOESSOMETHING' do", "end"]

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

    for element in @_confirmedElements
      strings.push indent + TEMPLATES[element.name](element.selector)

    strings.push TEMPLATES.it()[1]

    strings.join('\n')


window['Capycorder'] = Capycorder
