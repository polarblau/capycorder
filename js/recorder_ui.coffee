class RecorderUI

  $ui: null

  delayToHide: 5
  hideAfter: null

  getTemplate: ->
    """
      <div id="capycorder">
        <div class="prompt-name">
          <div class="capycorder-label">
            <img src="#{@chrome.extension.getURL('images/button_off.png')}" />
            Name your test. It
          </div>
          <div class="capycorder-input-wrapper">
            <input type="text" id="capycorder-spec-name" placeholder="should do something" />
          </div>
          <div class="capycorder-actions">
            <a href="#" class="cancel">Cancel</a>
            <button>OK</button>
          </div>
        </div>
        <div class="capture-actions">
          <div>
            <img src="#{@chrome.extension.getURL('images/button_capture_actions.png')}" />
            Interact with the page to record actions.
          </div>
        </div>
        <div class="capture-matchers">
          <div>
            <img src="#{@chrome.extension.getURL('images/button_capture_matchers.png')}" />
            Select text ranges or elements to record matchers.
          </div>
       </div>
        <div class="generate">
          <div>
            <img src="#{@chrome.extension.getURL('images/button_generate.png')}" />
            Thanks! The recorded spec has been copied to the clipboard.
          </div>
        </div>
      </div>
    """

  constructor: (options) ->
    @chrome = options.chrome

  _created: false
  create: ->
    unless @_created
      if window.top == window.self
        @$ui = $(@getTemplate())
        @$ui.appendTo('body').find('> div').hide()
        @_created = true

  showNamePrompt: (block = ->) ->
    @create()
    @_hideVisible =>
      $visible = @$ui.find('.prompt-name').show()
      @_showUI =>
        @$ui.find('.prompt-name input').trigger('focus')
      $visible
        .find('input')
        .val('')
        .end()
        .find('a')
        .one 'click', =>
          @_hideVisible()
          block(null)
        .end()
        .find('button')
        .one 'click', =>
          name = $visible.find('#capycorder-spec-name').val()
          @_hideVisible()
          block(name)
        .end()
        .find('#capycorder-spec-name').keypress (event) ->
          $visible.find('button').click() if event.which == 13

  show: (state) ->
    @_hideVisible =>
      selector = ".#{state.replace('.', '-')}"
      @$ui.find(selector).show()
      @_showUI()
      @$ui.one 'mouseover.recorderui', => @_hideVisible()
      @hideAfter = setTimeout @_hideVisible, @delayToHide * 1000

  _showUI: (block = ->) ->
    @$ui.animate top: '0px', 250, => block()

  _hideUI: (block = ->) ->
    @$ui.animate top: '-200px', 250, => block()

  _hideVisible: (block = ->) =>
    clearTimeout @hideAfter if @hideAfter?
    @$ui.off 'mouseover.recorderui'
    $visible = @$ui.find('div:visible')
    if $visible.length
      @_hideUI =>
        $visible.hide()
        block()
     else
       block()


window.RecorderUI = RecorderUI
