Events = require 'events'
EventTypes = require 'event-types'

module.exports = class DragonView
  constructor: (@dragon, domId, {@showSex, @showCharacteristics, @visibleTraits})->
    @showSex ?= true
    @showCharacteristics ?= false
    @visibleTraits ?= []

    @_addListeners(@dragon)
    @div = $(domId)[0]
    @div.classList.add 'dragon-view-parent'
    @_injectHtml()
    @_updateClasses()

  setDragon: (@dragon)->
    @_updateClasses()
    @_updateCharacteristics()
    @_updateSexLabel()

  setSexVisible: (@showSex) ->
    @_updateVisibility()

  setCharacteristicsVisible: (@showCharacteristics) ->
    @_updateVisibility()

  _addListeners: (dragon)->
    Events.addEventListener EventTypes.DRAGON.ALLELES_CHANGED, (evt)=>
      if evt.detail.dragon is @dragon
        @_updateClasses()
        @_updateCharacteristics()
        @_updateSexLabel()

  _updateClasses: ->
    @phenoView.setAttribute('class', '')
    @phenoView.classList.add 'dragon-view'
    for characteristic in @dragon.getAllCharacteristics()
      characteristic = characteristic.toLowerCase().replace(' ', '-')
      @phenoView.classList.add characteristic

  _updateVisibility: ->
    if @showSex
      @sexLabel.classList.remove('hidden') if @sexLabel.classList.contains('hidden')
    else
      @sexLabel.classList.add 'hidden'

    if @showCharacteristics
      @characteristicList.classList.remove('hidden') if @characteristicList.classList.contains('hidden')
    else
      @characteristicList.classList.add 'hidden'

  _updateCharacteristics: ->
    out = []
    for own trait, characteristic of @dragon.phenotype.characteristics
      continue if @visibleTraits.length > 0 and trait not in @visibleTraits
      out.push "<span class='trait'>#{trait}:</span> <span class='characteristic'>#{characteristic}</span>"

    @characteristicList.innerHTML = out.join('')

  _updateSexLabel: ->
    @sexLabel.innerHTML = if @dragon.sex is BioLogica.MALE then "male" else "female"

  _injectHtml: ->
    @phenoView = document.createElement 'div'
    @phenoView.classList.add 'dragon-view'
    @div.appendChild @phenoView
    for part in ['body','dead','fire','head','plates','scales','wings']
      partImg = document.createElement 'img'
      partImg.classList.add part
      partImg.src = "images/dragons/#{part}.png"
      @phenoView.appendChild partImg

    @sexLabel = document.createElement 'div'
    @sexLabel.classList.add 'sex-label'
    @sexLabel.classList.add 'hidden' unless @showSex
    @div.appendChild @sexLabel

    @characteristicList = document.createElement 'div'
    @characteristicList.classList.add 'characteristic-list'
    @characteristicList.classList.add 'hidden' unless @showCharacteristics
    @div.appendChild @characteristicList

    @_updateSexLabel()
    @_updateCharacteristics()

