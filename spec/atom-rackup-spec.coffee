AtomRackup = require '../lib/atom-rackup'
{WorkspaceView} = require 'atom'
# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomRackup", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('atom-rackup')

  describe "when the atom-rackup:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.atom-rackup')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'atom-rackup:start'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.atom-rackup')).toExist()
        atom.workspaceView.trigger 'atom-rackup:toggle'
        expect(atom.workspaceView.find('.atom-rackup')).not.toExist()

  describe "when the atom-rackup:start event is triggered", ->
    it "starts the server and updates the status bar", ->
      expect(atom.workspaceView.statusBar.find('.atom-rackup')).not.toExist()

      atom.workspaceView.trigger 'atom-rackup:start'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.atom-rackup').html()).toMatch(/^Listening/)

  describe "when the atom-rackup:stop event is triggered", ->
    it "stops the server and updates the status bar", ->
      expect(atom.workspaceView.statusBar.find('.atom-rackup')).not.toExist()

      atom.workspaceView.trigger 'atom-rackup:start'

      waitsForPromise ->
        activationPromise

      runs ->
        atom.workspaceView.trigger 'atom-rackup:stop'
        expect(atom.workspaceView.find('.atom-rackup').html()).toMatch(/^Stopping/)

  describe "when the atom-rackup:restart event is triggered", ->
    it "restarts the server updates the status bar", ->

      expect(atom.workspaceView.statusBar.find('.atom-rackup')).not.toExist()

      atom.workspaceView.trigger 'atom-rackup:start'

      waitsForPromise ->
        activationPromise

      runs ->
        atom.workspaceView.trigger 'atom-rackup:restart'
        expect(atom.workspaceView.find('.atom-rackup').html()).toMatch(/^Stopping/)
