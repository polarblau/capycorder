describe 'Capybara action generator', ->

  describe '#isScoped', ->

    it 'should return true if scope provided', ->
      generator = new Capybara.Generators.Action(scope: '#foo')
      expect(generator.isScoped()).toBeTruthy()

    it 'should return false if no scope provided', ->
      generator = new Capybara.Generators.Action
      expect(generator.isScoped()).toBeFalsy()

  describe 'templates', ->
    generator = null
    allOptions =
      scope: '#foo'
      locator: 'Foo'
      options:
        path: '/foo/bar'
        file: 'foo/bar.png'
        with: 'foobar'
        from: 'foo'

    describe '#scopeTemplate', ->

      beforeEach ->
        generator = new Capybara.Generators.Action(allOptions)

      it 'should return an array', ->
        expect(typeof generator.scopeToPartials()).toBe('object')

      it 'should match a tempate', ->
        out = generator.scopeToPartials()
        expect(out.length).toEqual(2)
        expect(out[0]).toBe("within('#foo') do")
        expect(out[1]).toBe('end')

    describe '#toString', ->

      expectations =
        'attachFile'  : "attach_file('Foo', 'foo/bar.png')"
        'check'       : "check('Foo')"
        'uncheck'     : "uncheck('Foo')"
        'choose'      : "choose('Foo')"
        'click_button': "click_button('Foo')"
        'fillIn'      : "fill_in('Foo', :with => 'foobar')"
        'select'      : "select('Foo', :from => 'foo')"
        'clickLink'   : "click_link('Foo')"
        'visitPath'   : "visit('/foo/bar')"

      for method, template of expectations

        it "should return correct template for #{method}", ->
          options = _.extend(allOptions, name: method)
          generator = new Capybara.Generators.Action(options)

          expect(generator.toString()).toBe(template)
