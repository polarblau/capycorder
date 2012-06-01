jasmine.getFixtures().fixturesPath = 'fixtures/capybara/recorders'

describe 'Capybara actions recorder', ->
  loadFixtures('actions_spec.html')

  recorder = null

  beforeEach ->
    recorder = new Capybara.Recorders.Actions

  describe '#start', ->

    it 'should attach events', ->
      console.log $('#jasmine-fixtures')

      expect($('#input-file')).toHandle('change.actionrecorder')

    # all events, meta test

  describe '#stop', ->

    it 'should detach events', ->

      # all events, meta test


