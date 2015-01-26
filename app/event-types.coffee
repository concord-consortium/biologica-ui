
###
  This is a simple helper library for dispatching custom events.
  While not strictly necessary, it also includes a polyfill for supporting
  event dispatching on browsers that don't have CustomEvent support.
###

module.exports = class EventTypes
  @DRAGON:
    ALLELES_CHANGED: 'alleles changed'
