{View} = require 'atom'

module.exports =
class AtomRackupView extends View
  @content: ->
    @div class: 'atom-rackup-status inline-block', =>
      @span class: 'server-status', outlet: 'status', tabindex: -1, ''

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-rackup:toggle", => @toggle()
    @attach()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  attach: ->
    atom.workspaceView.statusBar.appendLeft(this)

  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  update: (status) =>
    return unless @hasParent()
    @status.html(status)
