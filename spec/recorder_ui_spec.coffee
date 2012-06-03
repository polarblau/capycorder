describe 'RecoderUI', ->

  ui = null
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

    it 'should make the .capture-actions visible', ->
      expect($('body #capycorder .capture-actions')).not.toBeVisible()
      ui.show('capture.actions')
      expect($('body #capycorder .capture-actions')).toBeVisible()

    it 'should make the .capture-matchers visible', ->
      expect($('body #capycorder .capture-matchers')).not.toBeVisible()
      ui.show('capture.matchers')
      expect($('body #capycorder .capture-matchers')).toBeVisible()

    it 'should make the .generate visible', ->
      expect($('body #capycorder .generate')).not.toBeVisible()
      ui.show('generate')
      expect($('body #capycorder .generate')).toBeVisible()

  describe '#showNamePrompt', ->

    it 'should trigger #create', ->
      ui.showNamePrompt()
      expect($('body #capycorder')).toExist()

