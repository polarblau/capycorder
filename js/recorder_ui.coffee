class RecorderUI

  $ui: null

  delayToHide: 5
  hideAfter: null

  template:
    """
      <div id="capycorder">
        <div class="prompt-name">
          <strong>Capycorder</strong>
          Name your test. It "
          <input type="text" id="capycorder-spec-name" placeholder="should do something" />
          "
          <button>Okay</button>
          <a href="#" class="cancel">Cancel</a>
        </div>
        <div class="capture-actions">
          <strong>Capycorder</strong>
          Interact with the page to record actions.
        </div>
        <div class="capture-matchers">
          <strong>Capycorder</strong>
          Select text ranges or elements to record matchers.
        </div>
        <div class="generate">
          <strong>Capycorder</strong>
          Thanks! The recorded spec has been copied to the clipboard.
        </div>
      </div>
    """

  constructor: ->
    @create()

  create: ->
    @$ui = $(@template)
    @$ui.appendTo('body').find('div').hide()

  showNamePrompt: (block = ->) ->
    @_hideVisible =>
      $visible = @$ui.find('.prompt-name').show()
      @_showUI()
      $visible
        .find('input')
        .val('')
        .focus()
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
