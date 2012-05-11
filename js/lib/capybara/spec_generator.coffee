window.Capybara ||= {}

class Capybara.SpecGenerator

  lines: []

  constructor: ->
    # instantiate spec line generators for actions and matchers

  addLine: (data) ->
    # check what line type it is and generate spec line

  generate: ->
    # parse lines, nest by scoping
    # return string
    #
    #

###
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
###
