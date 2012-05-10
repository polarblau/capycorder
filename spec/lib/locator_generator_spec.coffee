describe 'LocatorGenerator', ->

  beforeEach ->
    @locator = new LocatorGenerator

  #

  describe 'inputs', ->

    beforeEach ->
      fixture =
        """
          <div>
            <label for="baa">Baa</label>
            <input name="bar" id="bat" type="password" />
            <input name="foo" type="text" />
            <label>Boo
              <input name="boo" id="boo" type="checkbox" />
            </label>
            <input name="baa" id="baa" type="checkbox" />
            <input type="button" value="Button!" />
            <input type="submit" value="Submit!" />
            <input type="reset" value="Reset!" />
            <button>Save</button>
            <label>Select me
              <select>
                <option value="foo">Foo</option>
              </select>
            <label>
          </div>
        """
      setFixtures fixture

    it 'should prefer the label of an input', ->
      $input = $('input[name=boo]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Boo', type: 'string')

    it 'should find a non-wrapping label for an input', ->
      $input = $('input[name=baa]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Baa', type: 'string')

    it 'should prefer the id name', ->
      $input = $('input[name=bar]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'bat', type: 'string')

    it 'should return the name if it exists', ->
      $input = $('input[name=foo]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'foo', type: 'string')

    it 'should return the value for a input of type button', ->
      $input = $('input[type=button]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Button!', type: 'string')

    it 'should return the value for a input of type submit', ->
      $input = $('input[type=submit]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Submit!', type: 'string')

    it 'should return the value for a input of type reset', ->
      $input = $('input[type=reset]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Reset!', type: 'string')

    it 'should return the value for a input of type reset', ->
      $input = $('input[type=reset]')
      locator = @locator.generate($input)
      expect(locator).toEqual(value: 'Reset!', type: 'string')

    it 'should return the text for a button', ->
      $button = $('button')
      locator = @locator.generate($button)
      expect(locator).toEqual(value: 'Save', type: 'string')

    it 'should return the text for a select', ->
      $select = $('select')
      locator = @locator.generate($select)
      expect(locator).toEqual(value: 'Select me', type: 'string')
