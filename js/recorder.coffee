init = ->
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
      when 'generate'
        # TODO: disable highlighting
        matchersRecorder.stop()

  chrome.extension.onRequest.addListener(stateChangesListener)

#

$(document).ready(init)

###
@highlighter = new SelectionBox

  _enableHighlighting: ->
    $(document).on ['mousemove', @namespace].join('.'), (e) =>
      e.preventDefault()
      e.stopPropagation()
      $('body').css('cursor', 'crosshair')
      @highlighter.highlight(e.target)

  _disableHighlighting: ->
    $(document).off ['mousemove', @namespace].join('.')
    $('body').css('cursor', '')
    @highlighter.hide()
###
