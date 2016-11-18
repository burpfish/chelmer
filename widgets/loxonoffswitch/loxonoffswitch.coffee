class Dashing.Loxonoffswitch extends Dashing.ClickableWidget
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

  toggleState: ->
    newState = if @get('state') == 'ON' then 'OFF' else 'ON'
    @set 'state', newState
    return newState

  queryState: ->

  postState: ->
    newState = @toggleState()
    loxSwitch(@get('device'), newState)

  setStateWithBoolean: (value) ->
    newState = if value == true then 'ON' else 'OFF' 
    @set 'state', newState

  ready: ->
    isDeviceOn(this, @get('device'), @setStateWithBoolean)
    
  onClick: (event) ->
    @postState()
