Events = require 'events'
EventTypes = require 'event-types'

module.exports = class DragonView
  constructor: (@dragon, domId)->
    @_addListeners(@dragon)
    @div = $(domId)[0]
    @_injectHtml()
    @_updateClasses()

  setDragon: (@dragon)->
    @_updateClasses()

  _addListeners: (dragon)->
    Events.addEventListener EventTypes.DRAGON.ALLELES_CHANGED, (evt)=>
      @_updateClasses() if evt.detail.dragon is @dragon

  _updateClasses: ->
    @div.setAttribute('class', '')
    @div.classList.add 'dragon-view'
    for characteristic in @dragon.getAllCharacteristics()
      characteristic = characteristic.toLowerCase().replace(' ', '-')
      @div.classList.add characteristic

  _injectHtml: ->
    for part in ['body','dead','fire','head','plates','scales','wings']
      partImg = document.createElement 'img'
      partImg.classList.add part
      partImg.src = "images/dragons/#{part}.png"
      @div.appendChild partImg
