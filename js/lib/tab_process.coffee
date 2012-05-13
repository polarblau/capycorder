# TODO: settings?
STATES = ['name', 'capture.actions', 'capture.matchers', 'generate', 'off']

class TabProcess

  id   : null
  state: null

  constructor: (options) ->
    @id                  = options.tab.id
    @state               = 'off'
    @stateChangeCallback = options.onStateChange
    @specs               = new Capybara.Specs(tabURL: options.tab.url)

  getState: ->
    @state

  getInfo: ->
    state: @getState()
    isNamed: @specs.name?

  setState: (state) ->
    @state = state
    @stateChangeCallback @state

  toNextState: ->
    state = STATES[_.indexOf(STATES, @state) + 1] || _.first(STATES)
    @setState state


window.TabProcess = TabProcess
