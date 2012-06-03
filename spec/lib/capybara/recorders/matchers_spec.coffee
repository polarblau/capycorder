jasmine.getFixtures().fixturesPath = 'fixtures'

describe 'Capybara matchers recorder', ->

  recorder   = null
  callback   = null
  fakeWindow = null

  beforeEach ->
    loadFixtures('capybara/recorders/matchers_spec.html')
    callback = jasmine.createSpy('afterCaptureCallback')
    recorder = new Capybara.Recorders.Matchers afterCapture: callback
    recorder.start()

  describe '#start', ->

    it 'should attach a callback with options for the document on mouseup', ->
      $('#div').trigger('mouseup')
      expect(callback).toHaveBeenCalledWith
        type    : 'matcher'
        name    : 'shouldHaveSelector'
        selector: '#div'
        scope   : null
        options : {}

    xit 'should attach a callback with options (content) for the document on mouseup', ->

      range = document.createRange()
      node = $('#div').get(0)
      range.selectNodeContents(node)

      $('#div').trigger('mouseup')
      expect(callback).toHaveBeenCalledWith
        type    : 'matcher'
        name    : 'shouldHaveSelector'
        selector: 'html > body > div#jasmine-fixtures > div#div'
        scope   : null
        options : { content: 'Foobar' }


  describe '#stop', ->

    beforeEach ->
      recorder.stop()

    it 'should detach the callback for the document on mouseup', ->
      $('#div').trigger('mouseup')
      expect(callback).not.toHaveBeenCalled()

