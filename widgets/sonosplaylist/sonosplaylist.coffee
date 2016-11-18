class Dashing.Sonosplaylist extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? 'OFF'
    set: (key, value) -> @_state = value

  @accessor 'icon',
    get: -> if @['icon'] then @['icon'] else
      if @get('state') == 'ON' then @get('iconoff') else @get('iconon')
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconon',
    get: -> @['iconon'] ? 'play'
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconoff',
    get: -> @['iconoff'] ? 'pause'
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
    if newState == 'ON' then sonosPlay(@get('device')) else sonosStop()

  ready: ->

  onClick: (event) ->
    @postState()
