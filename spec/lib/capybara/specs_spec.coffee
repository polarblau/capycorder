describe 'Capybara specs', ->

  specs = null
  ACTION_DATA_MOCK =
    type   : 'action',
    name   : 'clickLink',
    locator: 'foobar',
    scope  : null
    options: {}
  MATCHER_DATA_MOCK =
    type    : 'matcher',
    name    : 'shouldHaveSelector',
    selector: '#foo',
    scope   : null
    options : {}
  SCOPED_ACTION_DATA_MOCK =
    _.extend {}, ACTION_DATA_MOCK, scope: 'form-scope'

  beforeEach ->
    specs = new Capybara.Specs tabURL: '/foo'

  describe '#add', ->

    it 'should store the added generators', ->
      before = specs.generators.length
      specs.add { type: 'action' }
      expect(specs.generators.length).toBeGreaterThan(before)

  describe '#setName', ->

    it 'should change the specs name', ->
      specs.setName 'foo'
      expect(specs.name).toBe('foo')

  describe '#generate', ->

    it 'should generate basic structure', ->
      expectedOutput = """
      it 'SHOULDDOSOMETHING' do
        visit('/foo')
      end
      """
      expect(specs.generate()).toEqual(expectedOutput)

    describe 'actions', ->

      it 'should wrap action generator output', ->
        specs.add(ACTION_DATA_MOCK)
        expectedOutput = """
        it 'SHOULDDOSOMETHING' do
          visit('/foo')
          click_link('foobar')
        end
        """
        expect(specs.generate()).toEqual(expectedOutput)

      describe 'with scope', ->

        it 'should wrap the generator output', ->
          specs.add(SCOPED_ACTION_DATA_MOCK)
          expectedOutput = """
          it 'SHOULDDOSOMETHING' do
            visit('/foo')
            within('form-scope') do
              click_link('foobar')
            end
          end
          """
          expect(specs.generate()).toEqual(expectedOutput)

    describe 'matchers', ->

      it 'should wrap matcher generator output', ->
        specs.add(MATCHER_DATA_MOCK)
        expectedOutput = """
        it 'SHOULDDOSOMETHING' do
          visit('/foo')
          page.should have_selector('#foo')
        end
        """
        expect(specs.generate()).toEqual(expectedOutput)
