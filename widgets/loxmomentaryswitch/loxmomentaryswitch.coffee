class Dashing.Loxmomentaryswitch extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? 'OFF'
    set: (key, value) -> @_state = value

  @accessor 'icon',
    get: -> if @['icon'] then @['icon'] else
      if @get('state') == 'ON' then @get('iconon') else @get('iconoff')
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconon',
    get: -> @['iconon'] ? 'circle'
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconoff',
    get: -> @['iconoff'] ? 'circle-thin'
    set: Batman.Property.defaultAccessor.set

  @accessor 'icon-style', ->
    if @get('state') == 'ON' then 'switch-icon-on' else 'switch-icon-off'    

  turnOn: ->
    @set 'state', 'ON'
    loxPulse(@get('device'))

  turnOff: ->
    @set 'state', 'OFF'

  queryState: ->

  callWithDelay = (timeInMs, fn) -> setTimeout fn, timeInMs

  postState: ->
    @turnOn()
    callWithDelay 100, => @turnOff()

  ready: ->

  onClick: (event) ->
    @postState()
