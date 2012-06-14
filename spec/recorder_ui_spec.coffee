describe 'RecoderUI', ->

  ui = null
  ENTER_EVENT = $.Event 'keypress', 'which': 13
  CHROME =
    extension:
      getURL: (path) -> "../#{path}"

  beforeEach ->
    ui = new RecorderUI chrome: CHROME

  afterEach ->
    $('body #capycorder').remove()

  describe '#create', ->

    it 'should generate the necessary HTML and append it', ->
      expect($('body #capycorder')).not.toExist()
      ui.create()
      expect($('body #capycorder')).toExist()

    it 'should only generate the HTML once', ->
      ui.create()
      ui.create()
      expect($('body #capycorder').length).toEqual(1)

  describe '#show', ->
    beforeEach ->
      ui.create()

    it 'should make .capture-actions visible', ->
      expect($('body #capycorder .capture-actions')).not.toBeVisible()
      ui.show('capture.actions')
      expect($('body #capycorder .capture-actions')).toBeVisible()

    it 'should make .capture-matchers visible', ->
      expect($('body #capycorder .capture-matchers')).not.toBeVisible()
      ui.show('capture.matchers')
      expect($('body #capycorder .capture-matchers')).toBeVisible()

    it 'should make .generate visible', ->
      expect($('body #capycorder .generate')).not.toBeVisible()
      ui.show('generate')
      expect($('body #capycorder .generate')).toBeVisible()

  describe '#showNamePrompt', ->

    it 'should trigger #create', ->
      ui.showNamePrompt()
      expect($('body #capycorder')).toExist()

    it 'should show name prompt', ->
      ui.showNamePrompt()
      expect($('body #capycorder .prompt-name')).toBeVisible()

  describe 'submitting name prompt', ->

    beforeEach ->
      ui.showNamePrompt()

    it 'should submit the form when pressing ENTER', ->
      expect($('body #capycorder .prompt-name')).toBeVisible()
      spyOnEvent($('body #capycorder .prompt-name button'), 'click')
      runs ->
        $('#capycorder-spec-name').trigger(ENTER_EVENT)
      waits(ui.delayToHide * 1000)
      runs ->
        expect($('body #capycorder .prompt-name')).not.toBeVisible()


