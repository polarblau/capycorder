jasmine.getFixtures().fixturesPath = 'fixtures'

describe 'jquery.get_locator', ->

  beforeEach ->
    loadFixtures('jquery_plugins/jquery.get_locator.html')

  it 'should return the first attribute found', ->
    expect($('#bar').getLocator(['name', 'id'])).toEqual('foo')

  it 'should find the id', ->
    expect($('#bar').getLocator(['id'])).toEqual('bar')

  it 'should find the name', ->
    expect($('#bar').getLocator(['name'])).toEqual('foo')

  it 'should find the label', ->
    expect($('#bar').getLocator(['label'])).toEqual('Foobar')

  it 'should find the text', ->
    expect($('#bat').getLocator(['text'])).toEqual('Bat')

  it 'should find the value', ->
    expect($('#bar').getLocator(['value'])).toEqual('baz')

  it 'should find the image alt attribute', ->
    expect($('#bot').getLocator(['imgAlt'])).toEqual('Image foo')

