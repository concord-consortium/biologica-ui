Helpers = require('helpers')
MeiosisSupport = require('models/meiosis-support')
EventTypes = require('event-types')

module.exports = class DragonMeiosisView
  @_defaults:
    species: BioLogica.Species.Dragon
    hiddenGenes: []
    mode: 'offspring'  # 'offspring' or 'parent'
    swapping: 'none'   # 'none' or ... ???
    meiosisOwner: 'offspring'  # 'offspring', 'mother', 'father'
    width: 300
    height: 300
    jsonDataUrl: undefined

  constructor: (@dragon, domId, opts={}) ->
    @opts = Helpers.defaults opts, DragonMeiosisView._defaults
    @jsonData = null
    @motherData = null
    @fatherData = null
    @_parent = $(domId)
    @_setupListeners()
    @_reset()

  getLabelForAllele: (allele)->
    @opts.species.alleleLabelMap[allele]

  _setupListeners: ->
    Events.addEventListener EventTypes.MEIOSIS.RESET, (evt) =>
      if evt.detail.owner is @opts.meiosisOwner and evt.detail.mode is @opts.mode
        @_reset()
        Events.dispatchEvent EventTypes.MEIOSIS.GAMETE_SELECTED, {owner: @opts.meiosisOwner, gamete: null}
    Events.addEventListener EventTypes.MEIOSIS.GAMETE_SELECTED, (evt) =>
      if @opts.mode is 'offspring'
        if evt.detail.owner is 'mother'
          @motherData = evt.detail.gamete
        else
          @fatherData = evt.detail.gamete
        @_reset()

  _reset: ->
    @_setJsonData()
    @_injectHtml()
    @_initAnimation()

  _setJsonData: ->
    if @opts.mode is 'offspring'
      if @motherData? and @fatherData?
        @jsonData = { chromosomes: [] }
        @jsonData.chromosomes = @jsonData.chromosomes.concat(@motherData.chromosomes)
        @jsonData.chromosomes = @jsonData.chromosomes.concat(@fatherData.chromosomes)
      else if @motherData?
        @jsonData = @motherData
      else if @fatherData?
        @jsonData = @fatherData
      else
        @jsonData = null
      Events.dispatchEvent EventTypes.MEIOSIS.OFFSPRING_CREATED, {offspring: null}
    else if @dragon?
      @jsonData = MeiosisSupport.allelesToJSON(@dragon.getAlleleString())

  _initAnimation: ->
    @jsonData = @opts.jsonDataUrl unless @jsonData?

    options =
      mode: @opts.mode
      swap: @opts.swapping isnt 'none'
      owner: @opts.meiosisOwner
      mother: @motherData
      father: @fatherData
      segMoveSpeed: 5
      width: @opts.width
      height: @opts.height
      context: @
      loaded: @_animationLoaded
      animationComplete: @_animationComplete
      gameteSelected: @_gameteSelected
      playButtonPressed: @_playButtonPressed
      endButtonPressed: @_endButtonPressed
      reachedRecombination: @_reachedRecombination
      allelesSelected: @_allelesSelected
      swapCompleted: @_swapCompleted
      ySwapAttempted: @_ySwapAttempted

    @_injectHtml() unless @_div?
    if @jsonData?
      @_div.geniverse(@jsonData, options)

  _injectHtml: ->
    d = document.createElement 'div'
    d.classList.add 'meiosis'

    out = ''
    out += '<div class="cell"></div>'
    out += '<div class="controls">'

    out += '<div class="buttons">'
    out += '<button class="stop"><img src="images/meiosis/meiosis_stop_small.png" /></button>'
    out += '<button class="play"><img src="images/meiosis/meiosis_play_small.png" /></button>'
    out += '<button class="end"><img src="images/meiosis/meiosis_end_small.png" /></button>'
    if @opts.mode is 'parent'
      if @opts.swapping isnt 'none'
        out += '<button class="swap"><img src="images/meiosis/meiosis_exchange_16x16_monochrome.png" /></button>'
      out += '<button class="retry"><img src="images/meiosis/meiosis_retry_monochrome.png" /></button>'
    out += '</div>'

    out += '<div class="scrub"></div>'
    out += '</div>'

    d.innerHTML = out
    @_parent[0].innerHTML = ''
    @_parent[0].appendChild d
    @_div = $(d)

  _animationLoaded: ->
    undefined

  _animationComplete: ->
    if @opts.mode is 'offspring'
      alleles = MeiosisSupport.JSONToAlleles @motherData, @fatherData
      sex = MeiosisSupport.getOffspringSex @fatherData
      dragon = BioLogica.Organism.createOrganism @opts.species, alleles, sex
      Events.dispatchEvent EventTypes.MEIOSIS.OFFSPRING_CREATED, {offspring: dragon}

  _gameteSelected: (data)->
    Events.dispatchEvent EventTypes.MEIOSIS.GAMETE_SELECTED, {owner: @opts.meiosisOwner, gamete: data}

  _playButtonPressed: ->
    undefined

  _endButtonPressed: ->
    undefined

  _reachedRecombination: ->
    undefined

  _allelesSelected: ->
    undefined

  _swapCompleted: ->
    undefined

  _ySwapAttempted: ->
    undefined
