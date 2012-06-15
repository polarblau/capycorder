###
Based on jQuery-GetPath v0.01, by Dave Cardwell. (2007-04-27)
Extended by Florian Plank, Polarblau (2012)
###
$.fn.getSelector = (path = '') ->

  unless @length
    return $.error('No element found for $.getSelector.')

  # the end of the line
  return "html #{path}" if @is('html')

  selector = ''
  tagName  = @get(0).nodeName.toLowerCase()
  id       = @attr('id')
  klass    = @attr('class')

  selector = "##{id}" if id?

  # the id should be enough if the document is valid
  if $(selector + path).length == 1
    return selector + path

  # all classes
  if klass?
    selector = ".#{klass.split(/[\s\n]+/).join('.')}"

  # enough?
  if $(selector + path).length == 1
    return selector + path

  if !selector.length
    selector = tagName

  if $(selector + path).length == 1
    return selector + path

  if @index() > 0 && $(selector + path).length > 1
    selector += ":nth-child(#{@index()})"

  if $(selector + path).length == 1
    return selector + path

  # still here? let's climb one up
  return @parent().getSelector(' > ' + selector + path)
