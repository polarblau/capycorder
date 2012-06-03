jasmine.getFixtures().fixturesPath = 'fixtures'

describe 'jquery.get_selector', ->

  beforeEach ->
    loadFixtures('jquery_plugins/jquery.get_selector.html')

  it 'should return the id', ->
    expect($('#foo').getSelector()).toEqual('#foo')

  it 'should return nth child selector', ->
    expect($('.same:nth(2)').getSelector()).toEqual('.inner > .same:nth-child(2)')

  it 'should return nested selector', ->
    expect($('.outer div div div').getSelector()).toEqual('.outer > div > div > div')
