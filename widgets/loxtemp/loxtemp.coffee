class Dashing.Loxtemp extends Dashing.Widget
  constructor: ->
    super
    @queryState()
    @_min = 99
    @_max = 0

  @accessor 'state',
    get: -> if @_state then parseFloat(@_state).toFixed(1) else 0
    set: (key, value) -> 
      @_state = value
      if parseFloat(value) < parseFloat(@_min) then @set 'min', value
      if parseFloat(value) > parseFloat(@_max) then @set 'max', value

  @accessor 'heaterState',
    get: -> @_heaterState ? 'OFF'
    set: (key, value) -> @_heaterState = value

  @accessor 'min',
    get: -> parseFloat(@_min).toFixed(1)
    set: (key, value) -> 
      @_min = value

  @accessor 'max',
    get: -> parseFloat(@_max).toFixed(1)
    set: (key, value) -> 
      @_max = value

  @accessor 'iconon',
    get: -> @['iconon'] ? 'circle'
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconoff',
    get: -> @['iconoff'] ? 'circle-thin'
    set: Batman.Property.defaultAccessor.set
    
  @accessor 'icon',
    get: -> if @['icon'] then @['icon'] else
      if @get('heaterState') == 'ON' then @get('iconon') else @get('iconoff')
    set: Batman.Property.defaultAccessor.set

  setValue: (value) ->
    @set 'state', value

  queryState: ->

  onData: (data) ->
    @set 'state', data.value

  ready: ->
    getTemp(this, @get('device'), @setValue)
