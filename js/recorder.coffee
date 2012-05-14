init = ->
  # these need to be available across state changes
  [ui, recorder] = [new RecorderUI, null]

  # tell the background that the tab has been loaded
  chrome.extension.sendRequest name: 'loaded'

  # listen for messages from the background
  chrome.extension.onRequest.addListener (request) ->
    switch request.name
      when 'stateChanged'
        state = request.state

        recorderOptions =
          scope: document
          afterCapture: (dataAsJSON) ->
            chrome.extension.sendRequest name: 'captured', data: dataAsJSON

        switch state
          when 'name'
            ui.showNamePrompt (name) ->
              chrome.extension.sendRequest
                name: 'named', specsName: name

          when 'capture.actions'
            recorder = new Capybara.Recorders.Actions recorderOptions
            recorder.start()

          when 'capture.matchers'
            blurFocused()
            recorder.stop() if recorder?
            recorder = new Capybara.Recorders.Matchers recorderOptions
            recorder.start()
            enableHighlighting()

          when 'generate'
            recorder.stop() if recorder?
            disableHighlighting()

        ui.show state if state not in ['off', 'name']

  # Makes sure that all input values are included
  window.onbeforeunload = blurFocused


blurFocused = ->
  $('input:focus').blur()
  null

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
  if highlighter?
    $(document).off 'mousemove.highlight'
    $('body').css('cursor', '')
    highlighter.hide()

#

$(document).ready(init)
