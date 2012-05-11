# TODO: wrap these things into methods?

specs = null

# state for the whole extension:
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

  switch state
    when 'capture.actions'
      specs = new Capybara.Specs(tabURL: tab.url)
    when 'generate'
      output = specs.generate()
      $('#clipboard').val(output).focus().select()
      document.execCommand('copy')

# toggle recording when extension icon clicked
chrome.browserAction.onClicked.addListener(changeToNextState)


listener = (request, sender, sendResponse) ->
  switch request.name
    when 'captured'
      specs.add request.data

chrome.extension.onRequest.addListener listener
