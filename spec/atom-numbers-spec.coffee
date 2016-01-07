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
