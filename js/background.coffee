# create a new process for each tab
processes = {}

findOrCreateTabProcess = (tab) ->
  process = processes[tab.id]

  unless process?
    process = new TabProcess
      tab          : tab
      onStateChange: (state) ->
        chrome.tabs.sendRequest tab.id, state: state
        chrome.browserAction.setIcon
          path : "images/button_#{state.replace('.', '_')}.png"
          tabId: tab.id
    processes[tab.id] = process
  process

# ------------------------------------------------------------------------------
# Listen to incoming requests from tabs:
#
tabsListener = (request, sender, sendResponse) ->
  process = findOrCreateTabProcess sender.tab

  switch request.name
    when 'captured'
      process.specs.add request.data

    when 'loaded'
      process.setState

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


chrome.browserAction.onClicked.addListener buttonListener

