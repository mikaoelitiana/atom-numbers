AtomNumbers = require '../lib/atom-numbers'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Atom Numbers", ->
  [workspaceElement, activationPromise, editor] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.workspace.open()

    waitsForPromise ->
      atom.packages.activatePackage('atom-numbers')

    runs ->
      editor = atom.workspace.getActiveTextEditor()

  describe "Increment & decrement numbers", ->

    it "should decrement selected number's value by 1", ->
      editor.setText('I can count to 3')
      editor.setCursorScreenPosition([0,15])
      editor.selectToScreenPosition([0,16])
      atom.commands.dispatch workspaceElement, 'atom-numbers:decrement'
      expect(editor.getText()).toEqual('I can count to 2')

    it "should increment selected number's value by 1", ->
      editor.setText('I can count to 3')
      editor.setCursorScreenPosition([0,15])
      editor.selectToScreenPosition([0,16])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment'
      expect(editor.getText()).toEqual('I can count to 4')

  describe "Special numbers", ->
    it "should insert PI value", ->
      editor.setText('The value of Pi is ')
      atom.commands.dispatch workspaceElement, 'atom-numbers:pi'
      expect(editor.getText()).toEqual('The value of Pi is 3.14159265359')

  describe "SemVer", ->
    it "should match SemVer expression only", ->
      expect(AtomNumbers._isSemVer "1.0.0").toEqual(true)
      expect(AtomNumbers._isSemVer "1.2.3").toEqual(true)
      expect(AtomNumbers._isSemVer "1..3").toEqual(false)
      expect(AtomNumbers._isSemVer "3").toEqual(true)
      expect(AtomNumbers._isSemVer "version").toEqual(false)
    it "should get correct parts from SemVer expression", ->
      ver = AtomNumbers._getSemVerParts '1.2.3'
      expect(ver).toEqual({major: 1, minor: 2, patch: 3})
      ver = AtomNumbers._getSemVerParts '2.6.9'
      expect(ver).toEqual({major: 2, minor: 6, patch: 9})
      ver = AtomNumbers._getSemVerParts '2.5'
      expect(ver).toEqual({major: 2, minor: 5, patch: 0})
      ver = AtomNumbers._getSemVerParts '5'
      expect(ver).toEqual({major: 5, minor: 0, patch: 0})
    it "should increment major version", ->
      next = AtomNumbers._incrementMajor '1.2.3'
      ver = AtomNumbers._getSemVerParts next
      expect(ver).toEqual({major: 2, minor: 0, patch: 0})
      next = AtomNumbers._incrementMajor '2.3'
      ver = AtomNumbers._getSemVerParts next
      expect(ver).toEqual({major: 3, minor: 0, patch: 0})
      next = AtomNumbers._incrementMajor '3'
      ver = AtomNumbers._getSemVerParts next
      expect(ver).toEqual({major: 4, minor: 0, patch: 0})
    it "should increment major version of selected text", ->
      editor.setText('Version 1.2.3')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-major'
      expect(editor.getText()).toEqual('Version 2.0.0')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-major'
      expect(editor.getText()).toEqual('Version 3.0.0')
