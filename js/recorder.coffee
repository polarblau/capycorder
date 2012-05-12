init = ->
  chrome.extension.sendRequest name: 'loaded'

  stateChangesListener = (request, sender, sendResponse) ->

    options =
      scope: document
      afterCapture: (dataAsJSON) ->
        chrome.extension.sendRequest name: 'captured', data: dataAsJSON

    actionsRecorder = new Capybara.Recorders.Actions(options)
    matchersRecorder = new Capybara.Recorders.Matchers(options)

    switch request.state
      when 'capture.actions'
        actionsRecorder.start()
      when 'capture.matchers'
        # TODO: enable highlighting
        actionsRecorder.stop()
        matchersRecorder.start()
        enableHighlighting()
      when 'generate'
        matchersRecorder.stop()
        disableHighlighting()

  chrome.extension.onRequest.addListener(stateChangesListener)

# Highlighting
# TODO: move this into mini class?
highlighter = null

enableHighlighting = ->
  highlighter ||= new SelectionBox
  $(document).on 'mousemove.highlight', (e) =>
    e.preventDefault()
    e.stopPropagation()
    $('body').css('cursor', 'crosshair')
    highlighter.highlight(e.target)

disableHighlighting = ->
  $(document).off 'mousemove.highlight'
  $('body').css('cursor', '')
  highlighter.hide()

#

$(document).ready(init)
