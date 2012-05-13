window.Capybara ||= {}

class Capybara.Specs

  generators: []

  constructor: (options) ->
    @tabURL = options.tabURL

  add: (data) ->
    # check what line type it is and generate spec line
    switch data.type
      when 'action'
        @generators.push new Capybara.Generators.Action(data)
      when 'matcher'
        @generators.push new Capybara.Generators.Matcher(data)

  setName: (name) ->
    @name = name


  # TODO: it might make sense to implement the scope as mini class
  #       this model is still not flexible enough, either
  generate: ->
    [depth, strings, scope] = [0, [], null]

    # opening RSPEC's #it
    strings.push "it '#{@name || "SHOULDDOSOMETHING"}' do"
    depth++

    # call #visit
    path = @_parseURL(@tabURL).pathname
    strings.push @_indent("visit('#{path}')", depth)

    # add lines for generators
    for generator in @generators

      if generator.isScoped()
        generatorScope = generator.scopeToPartials()

        # currently in different scope,
        # first close previous scope
        if scope? && scope.join('') != generatorScope.join('')
          strings.push @_indent(_.last(generatorScope), --depth)
          scope = null

        # open new scope for current generator
        unless scope
          scope = generatorScope
          strings.push @_indent(_.first(generatorScope), depth++)
      else
        # close previous scope if generator not scoped
        if scope?
          strings.push @_indent(_.last(scope), --depth)
          scope = null

      strings.push @_indent(generator.toString(), depth)

    # close any open scope
    if scope?
      strings.push @_indent(_.last(scope), --depth)

    # closing RSPEC's #it
    strings.push 'end'

    strings.join('\n')


  #

  _indent: (line, depth = 0, indentation = '  ') ->
    while depth-- > 0
      line = indentation + line
    line

  _parseURL: (url) ->
    a = document.createElement('a')
    a.href = url
    a
