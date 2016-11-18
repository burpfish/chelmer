class Dashing.Sonosvolume extends Dashing.ClickableWidget

  constructor: ->
    super
    $(@node).on 'mousedown', (evt) => @mouseDown evt
    $(@node).on 'mouseup', (evt) => @mouseUp evt
    $(@node).on 'mouseout', (evt) => @mouseOut evt

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
    sonosPlayPause()
    return newState

  postState: ->
    newState = @toggleState()
    if newState == 'ON' then sonosPlay() else sonosStop()

  volUp: ->
    sonosVolUp ''
    if !@pressTimer
      @pressTimer = setInterval ->
        sonosVolUp ''
      , 100
    false

  volDown: ->
    sonosVolDown ''
    if !@pressTimer
      @pressTimer = setInterval ->
        sonosVolDown ''
      , 100
    false

  clearVolTimeout: ->
    console.log(">> clearing " + @pressTimer)
    clearTimeout(@pressTimer)
    @pressTimer = null

  onClick: (event) ->
    if event.target.id == "playOrPause"
      @toggleState()
    else if event.target.id == "previous"
      sonosPrevious()
    else if event.target.id == "next"
      sonosNext()
    else if event.target.id == "davePlaylist"
      sonosDave()
    else if event.target.id == "annaPlaylist"
      sonosAnna()

  mouseUp: (event) ->
    @clearVolTimeout()

  mouseOut: (event) ->
    @clearVolTimeout()

  mouseDown: (event) ->
    if event.target.id == "volUp"
      @volUp()
    else if event.target.id == "volDown"
      @volDown()

