# state control for the whole extension:
state  = 'off'
states = 'recording confirming printing off'.split(' ')

changeToNextState = (tab) ->
  state = states[_.indexOf(states, state) + 1] || _.first(states)

  # broadcast new state to tab
  chrome.tabs.sendRequest tab.id, state: state, tabURL: tab.url, ->

  # update button
  chrome.browserAction.setIcon
    path : "images/button_#{state}.png"
    tabId: tab.id

# toggle recording when extension icon clicked
chrome.browserAction.onClicked.addListener(changeToNextState)


# general listener for all requests from content script
listener = (request, sender, sendResponse) ->
  switch request.name
    when 'copy'
      $textarea = $('#clipboard').val(request.text).focus().select()
      document.execCommand('copy')
    when 'captured'
      console.log 'captured:', request


chrome.extension.onRequest.addListener listener
