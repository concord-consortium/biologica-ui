
###
  This is a simple helper class for defining event types.
###

module.exports = class EventTypes
  @DRAGON:
    ALLELES_CHANGED: 'alleles changed'
  @MEIOSIS:
    GAMETE_SELECTED: 'meiosis.gamete-selected'
    RESET: 'meiosis.retry'
    OFFSPRING_CREATED: 'meiosis.offspring-created'
