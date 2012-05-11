window.Capybara     ||= {}
Capybara.Generators ||= {}

class Capybara.Generators.Matcher

  templates:
    shouldHaveSelector: (data) ->
      "page.should have_selector('#{data.selector}')"

    shouldHaveContent: (data) ->
      "page.should have_content('#{data.options.content}')"

  scopeTemplate: (locator) ->
    ["within_form('#{locator}') do", "end"]


  constructor: (data) ->
    @data = data

  isScoped: ->
    @data.scope?

  scopeToPartials: ->
    if @isScoped
      @scopeTemplate @data.scope

  toString: ->
    @templates[@data.name](@data)
