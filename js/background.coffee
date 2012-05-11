# TODO: wrap these things into methods?

# state control for the whole extension:
state  = 'off'
states = 'capture.actions capture.matchers generate off'.split(' ')

changeToNextState = (tab) ->
  state = states[_.indexOf(states, state) + 1] || _.first(states)

  # broadcast new state to tab
  chrome.tabs.sendRequest tab.id, state: state, tabURL: tab.url, ->

  # update button
  chrome.browserAction.setIcon
    path : "images/button_#{state.replace('.', '_')}.png"
    tabId: tab.id

# toggle recording when extension icon clicked
chrome.browserAction.onClicked.addListener(changeToNextState)

# TODO: get tab.url when state initially set to 'capture.actions'
generator = new Capybara.SpecGenerator

###
generateAndCopy: (generator) ->
  specs = generator.generate()
  $('#clipboard').val(specs).focus().select()
  document.execCommand('copy')
  specs
###

listener = (request, sender, sendResponse) ->
  switch request.name
    when 'captured'
      console.log "captured!", request.data


chrome.extension.onRequest.addListener listener
