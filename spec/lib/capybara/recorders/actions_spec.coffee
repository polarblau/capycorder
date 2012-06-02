jasmine.getFixtures().fixturesPath = 'fixtures/capybara/recorders'

describe 'Capybara actions recorder', ->

  recorder = null
  callback = null

  beforeEach ->
    loadFixtures('actions_spec.html')
    callback = jasmine.createSpy('afterCaptureCallback')
    recorder = new Capybara.Recorders.Actions afterCapture: callback
    recorder.start()

  describe '#start', ->

    it 'should attach a callback with options for file inputs on change', ->
      $('#input-file').trigger('change')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'attachFile'
        locator: 'input-file'
        scope  : null
        options: { file : '' }

    it 'should attach a callback with options for checkbox inputs on check', ->
      $('#input-checkbox').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'check'
        locator: 'input-checkbox'
        scope  : null
        options: {}

    it 'should attach a callback with options for checkbox inputs on uncheck', ->
      $('#input-checkbox').trigger('click').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'uncheck'
        locator: 'input-checkbox'
        scope  : null
        options: {}

    it 'should attach a callback with options for radio inputs on click', ->
      $('#input-radio').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'choose'
        locator: 'input-radio'
        scope  : null
        options: {}

    it 'should attach a callback with options for submit button inputs on click', ->
      $('#input-submit').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'clickButton'
        locator: 'input-submit'
        scope  : null
        options: {}

    it 'should attach a callback with options for reset button inputs on click', ->
      $('#input-reset').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'clickButton'
        locator: 'input-reset'
        scope  : null
        options: {}

    it 'should attach a callback with options for button button inputs on click', ->
      $('#input-button').trigger('click')
      expect(callback).toHaveBeenCalledWith
        type   : 'action'
        name   : 'clickButton'
        locator: 'input-button'
        scope  : null
        options: {}

  describe '#stop', ->

    beforeEach ->
      recorder.stop()

    it 'should detach the callback for file inputs on change', ->
      $('#input-file').trigger('change')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach a callback with options for checkbox inputs on check', ->
      $('#input-checkbox').trigger('click')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach the callback for checkbox inputs on uncheck', ->
      $('#input-checkbox').trigger('click').trigger('click')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach the callback for radio inputs on click', ->
      $('#input-radio').trigger('click')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach the callback for submit button inputs on click', ->
      $('#input-submit').trigger('click')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach the callback for reset button inputs on click', ->
      $('#input-reset').trigger('click')
      expect(callback).not.toHaveBeenCalled()

    it 'should detach the callback for button button inputs on click', ->
      $('#input-button').trigger('click')
      expect(callback).not.toHaveBeenCalled()
