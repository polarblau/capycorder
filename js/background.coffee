# create a new process for each tab
processes = {}

findOrCreateTabProcess = (tab) ->
  process = processes[tab.id]

  unless process?
    process = new TabProcess
      tab          : tab
      onStateChange: (state) ->
        setTabButtonState tab, state
        broadcastState tab, state
    processes[tab.id] = process
  process

setTabButtonState = (tab, state) ->
  chrome.browserAction.setIcon
    path : "images/button_#{state.replace('.', '_')}.png"
    tabId: tab.id

broadcastState = (tab, state) ->
  data = name: 'stateChanged', state: state
  chrome.tabs.sendRequest tab.id, data

# ------------------------------------------------------------------------------
# Listen to incoming requests from tabs:
#
tabsListener = (request, sender, sendResponse) ->
  process = findOrCreateTabProcess sender.tab

  switch request.name
    when 'captured'
      process.specs.add request.data

    when 'loaded'
      state = process.getState()
      setTabButtonState sender.tab, state
      broadcastState sender.tab, state

    when 'named'
      process.specs.setName request.specsName
      process.toNextState()

chrome.extension.onRequest.addListener tabsListener


# ------------------------------------------------------------------------------
# Listen to button click events:
#
buttonListener = (tab) ->
  process = findOrCreateTabProcess tab
  process.toNextState()

  # TODO: move into tab process?
  switch process.getState()
    when 'generate'
      output = process.specs.generate()
      $('#clipboard').val(output).focus().select()
      document.execCommand('copy')
      # remove process
      delete processes[process.id]


chrome.browserAction.onClicked.addListener buttonListener

