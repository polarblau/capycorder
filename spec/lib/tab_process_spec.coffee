describe 'TabProcess', ->

  process = null
  MOCK_OPTIONS =
    tab: { id: 1 }
    onStateChange: ->

  beforeEach ->
    process = new TabProcess MOCK_OPTIONS

  describe '#setState', ->

    it 'should set the state for the process', ->
      process.setState('foo')
      expect(process.state).toEqual('foo')

  describe '#getState', ->

    it 'should return "off" by default', ->
      expect(process.state).toEqual('off')

  describe '#toNextState', ->

    it 'should return "name" after first call', ->
      process.toNextState()
      expect(process.state).toEqual('name')

    it 'should return "capture.actions" after second call', ->
      process.toNextState()
      process.toNextState()
      expect(process.state).toEqual('capture.actions')

    it 'should return "capture.matchers" after third call', ->
      process.toNextState()
      process.toNextState()
      process.toNextState()
      expect(process.state).toEqual('capture.matchers')

    it 'should return "generate" after fourth call', ->
      process.toNextState()
      process.toNextState()
      process.toNextState()
      process.toNextState()
      expect(process.state).toEqual('generate')

    it 'should return "off" again after fifth call', ->
      process.toNextState()
      process.toNextState()
      process.toNextState()
      process.toNextState()
      process.toNextState()
      expect(process.state).toEqual('off')


