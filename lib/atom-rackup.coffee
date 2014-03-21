AtomRackupView = require './atom-rackup-view'
ChildProcess = require 'child_process'

module.exports =
  atomRackupView: null
  configDefaults:
    port: 8080

  activate: (state) ->
    atom.workspaceView.command "atom-rackup:start", => @start()
    atom.workspaceView.command "atom-rackup:stop", => @stop()
    atom.workspaceView.command "atom-rackup:restart", => @restart()
    @atomRackupView = new AtomRackupView(state.atomRackupViewState)
    @updateStatus()

  deactivate: ->
    @rackup.kill() if @rackup
    @atomRackupView.destroy()

  serialize: ->
    atomRackupViewState: @atomRackupView.serialize()

  start: ->
    @rackup = ChildProcess.spawn 'bundle', ['exec', 'rackup', '-p', atom.config.get "atom-rackup.port"],
      cwd: atom.project.getPath()
    @updateStatus()
    @rackup.on 'close', (code) =>
      @rackup = undefined
      @updateStatus()

  stop: ->
    @rackup.kill() if @rackup
    @updateStatus()

  restart: ->
    @rackup.on 'close', (code) =>
      @start()
    @rackup.kill() if @rackup
    @updateStatus()

  status: ->
    switch
      when @rackup is undefined then ""
      when @rackup.killed then "Stopping"
      else "Listening: " + atom.config.get "atom-rackup.port"

  updateStatus: ->
    @atomRackupView.update @status()
