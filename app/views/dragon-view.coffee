module.exports = class DragonView
  constructor: (@dragon, domId)->
    @div = $(domId)[0]
    @_injectHtml()
    @_updateClasses()

  setDragon: (@dragon)->
    @_updateClasses()

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
