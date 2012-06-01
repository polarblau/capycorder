describe 'Capybara matcher generator', ->

  describe '#isScoped', ->

    it 'should return true if scope provided', ->
      generator = new Capybara.Generators.Matcher(scope: '#foo')
      expect(generator.isScoped()).toBeTruthy()

    it 'should return false if no scope provided', ->
      generator = new Capybara.Generators.Matcher
      expect(generator.isScoped()).toBeFalsy()

  describe 'templates', ->
    generator = null
    allOptions =
      scope: '#foo'
      selector: '.foo.bar'
      options:
        content: 'Foo bar'

    describe '#scopeTemplate', ->

      beforeEach ->
        generator = new Capybara.Generators.Matcher(allOptions)

      it 'should return an array', ->
        expect(typeof generator.scopeToPartials()).toBe('object')

      it 'should match a tempate', ->
        out = generator.scopeToPartials()
        expect(out.length).toEqual(2)
        expect(out[0]).toBe("within_form('#foo') do")
        expect(out[1]).toBe('end')

    describe '#toString', ->

      expectations =
        'shouldHaveSelector': "page.should have_selector('.foo.bar')"
        'shouldHaveContent' : "page.should have_content('Foo bar')"

      for method, template of expectations

        it "should return correct template for #{method}", ->
          options = _.extend(allOptions, name: method)
          generator = new Capybara.Generators.Matcher(options)

          expect(generator.toString()).toBe(template)

