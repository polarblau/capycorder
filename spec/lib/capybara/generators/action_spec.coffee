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

      it 'should return correct template for attachFile', ->
        options = _.extend(allOptions, name: 'attachFile')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("attach_file('Foo', 'foo/bar.png')")

      it 'should return correct template for check', ->
        options = _.extend(allOptions, name: 'check')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("check('Foo')")

      it 'should return correct template for uncheck', ->
        options = _.extend(allOptions, name: 'uncheck')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("uncheck('Foo')")

      it 'should return correct template for choose', ->
        options = _.extend(allOptions, name: 'choose')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("choose('Foo')")

      it 'should return correct template for clickButton', ->
        options = _.extend(allOptions, name: 'clickButton')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("click_button('Foo')")

      it 'should return correct template for fillIn', ->
        options = _.extend(allOptions, name: 'fillIn')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("fill_in('Foo', :with => 'foobar')")

      it 'should return correct template for select', ->
        options = _.extend(allOptions, name: 'select')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("select('Foo', :from => 'foo')")

      it 'should return correct template for clickLink', ->
        options = _.extend(allOptions, name: 'clickLink')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("click_link('Foo')")

      it 'should return correct template for visitPath', ->
        options = _.extend(allOptions, name: 'visitPath')
        generator = new Capybara.Generators.Action(options)
        expect(generator.toString()).toBe("visit('/foo/bar')")
