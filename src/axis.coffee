uuid = require 'uuid'
d3 = require 'd3'

defaults =
  neatline: true

styleAxis = (g)->
  g.selectAll 'path.domain'
    .attr fill: 'none', stroke: 'black'
  g.selectAll '.tick line'
    .attr stroke: '#000000'

xaxis = (ax)->
  g = null
  label = null
  tickOffset = 10
  labelSize = 10
  labelOffset = 22

  _y = d3.svg.axis()

  y = ->
    g = d3.select(@)
      .append("g")
        .attr class: "x axis"

    g.append "text"
      .attr
        class: 'label'
      .style 'text-anchor': "middle"
      .text label
    g.call _y
    g.call styleAxis
    y.update()

  y.update = ->
    sz = ax.plotArea.size()

    g.attr
      transform: "translate(0,#{sz.height})"

    g.select 'text.label'
      .attr
        transform: "translate(#{sz.width/2},0)"
        'font-size': labelSize
        dy: labelOffset

    g.selectAll ".tick text"
      .attr
        'text-anchor':"middle"
        "font-size": 10

    if ax.grid()
      g.selectAll '.tick .grid'
        .attr x1: sz.height

  y.tickOffset = (d)->
    return tickOffset unless d?
    tickOffset = d
    return y

  y.label = (d)->
    return label unless d?
    label = d
    return y

  y.labelOffset = (d)->
    return labelOffset unless d?
    labelOffset = d
    return y

  for k,v of _y
    y[k] = v

  y.scale ax.scale.x
  y.orient "bottom"

  return y

yaxis = (ax)->
  g = null
  label = null
  labelSize = 10
  labelOffset = 20
  tickOffset = 10
  _despined = false

  _y = d3.svg.axis()

  y = ->
    g = d3.select(@)
      .append("g")
        .attr class: "y axis"

    g.append "text"
      .attr
        class: 'label'
        dy: -labelOffset
      .style 'text-anchor': "middle"
      .text label
    if not _despined
      g
        .call _y
        .call styleAxis

    y.update()

  y.update = ->
    sz = ax.plotArea.size()
    right = y.orient() == 'right'
    rot = 90
    rot *= -1 if not right

    g.select 'text.label'
      .attr
        transform: "translate(0,#{sz.height/2})rotate(#{rot})"
        'font-size': labelSize

    g.selectAll ".tick text"
      .attr
        'text-anchor':"middle"
        "font-size": 10

    if ax.grid()
      g.selectAll '.tick .grid'
        .attr x1: sz.width

    if right
      g.attr transform: "translate(#{sz.width},0)"

  y.tickOffset = (d)->
    return tickOffset unless d?
    tickOffset = d
    return y

  y.label = (d)->
    return label unless d?
    label = d
    return y

  y.labelOffset = (d)->
    return labelOffset unless d?
    labelOffset = d
    return y

  y.despine = ->
    _despined = true
    return y

  for k,v of _y
    y[k] = v

  y.scale ax.scale.y
  y.orient "left"

  return y

module.exports =
  x: xaxis
  y: yaxis
