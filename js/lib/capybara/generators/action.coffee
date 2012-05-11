window.Capybara     ||= {}
Capybara.Generators ||= {}

class Capybara.Generators.Action

  templates:
    attachFile:(data) ->
      "attach_file('#{data.locator}', '#{data.options.file}')"

    check: (data) ->
      "check('#{data.locator}')"

    uncheck: (data) ->
      "uncheck('#{data.locator}')"

    choose: (data) ->
      "choose('#{data.locator}')"

    clickButton: (data) ->
      "click_button('#{data.locator}')"

    fillIn: (data) ->
      "fill_in('#{data.locator}', :with => '#{data.options.with}')"

    select: (data) ->
      "select('#{data.locator}', :from => '#{data.options.from}')"

    clickLink: (data) ->
      "click_link('#{data.locator}')"

    visitPath: (data) ->
      "visit('#{data.options.path}')"

  scopeTemplate: (locator) ->
    ["within('#{locator}') do", "end"]

  #

  constructor: (data) ->
    @data = data

  isScoped: ->
    @data.scope?

  scopeToPartials: ->
    if @isScoped
      @scopeTemplate @data.scope

  toString: ->
    @templates[@data.name](@data)
