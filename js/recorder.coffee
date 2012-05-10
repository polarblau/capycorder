# TODO: move this out into a own file or utilities space
window.Clipboard =
  copy: (text) ->
    # #execCommand is only available to background pages
    chrome.extension.sendRequest name: 'copy', text: text

capycorder = new Capycorder
capycorder.bind 'captured', (data) ->
  chrome.extension.sendRequest _.extend(name: 'captured', data)

# listen to state changes
stateChangesListener = (request, sender, sendResponse) ->
  if request.state == 'recording'
    # TODO: moving the Capybara code generator out of the
    #       Capycorder class will allow it to set this directly
    #       in the background page:
    capycorder.setTabURL(request.tabURL)
  capycorder.switchState request.state

chrome.extension.onRequest.addListener(stateChangesListener)
