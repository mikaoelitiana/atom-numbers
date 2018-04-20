AtomNumbers = require '../lib/atom-numbers'
Numbers = require '../lib/numbers'

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

    it "should increment number having unity", ->
      editor.setText('I have $50')
      editor.setCursorScreenPosition([0,7])
      editor.selectToScreenPosition([0,10])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment'
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment'
      expect(editor.getText()).toEqual('I have $52')
      editor.setText('Up 326px')
      editor.setCursorScreenPosition([0,3])
      editor.selectToScreenPosition([0,8])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment'
      expect(editor.getText()).toEqual('Up 327px')
      expect(Numbers.incrementNumber '345px', 1).toEqual('346px')

  describe "Special numbers", ->
    it "should insert PI value", ->
      editor.setText('The value of Pi is ')
      atom.commands.dispatch workspaceElement, 'atom-numbers:pi'
      expect(editor.getText()).toEqual('The value of Pi is 3.14159265359')

  describe "SemVer", ->
    it "should match SemVer expression only", ->
      expect(Numbers.isSemVer "1.0.0").toEqual(true)
      expect(Numbers.isSemVer "1.2.3").toEqual(true)
      expect(Numbers.isSemVer "1..3").toEqual(false)
      expect(Numbers.isSemVer "3").toEqual(true)
      expect(Numbers.isSemVer "version").toEqual(false)

    it "should get correct parts from SemVer expression", ->
      ver = Numbers.getSemVerParts '1.2.3'
      expect(ver).toEqual({major: 1, minor: 2, patch: 3})
      ver = Numbers.getSemVerParts '2.6.9'
      expect(ver).toEqual({major: 2, minor: 6, patch: 9})
      ver = Numbers.getSemVerParts '2.5'
      expect(ver).toEqual({major: 2, minor: 5, patch: 0})
      ver = Numbers.getSemVerParts '5'
      expect(ver).toEqual({major: 5, minor: 0, patch: 0})

    it "should increment major version", ->
      next = Numbers.incrementMajor '1.2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 2, minor: 0, patch: 0})
      next = Numbers.incrementMajor '2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 3, minor: 0, patch: 0})
      next = Numbers.incrementMajor '3'
      ver = Numbers.getSemVerParts next
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

    it "should increment minor version", ->
      next = Numbers.incrementMinor '1.2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 1, minor: 3, patch: 0})
      next = Numbers.incrementMinor '2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 2, minor: 4, patch: 0})
      next = Numbers.incrementMinor '3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 3, minor: 1, patch: 0})

    it "should increment minor version of selected text", ->
      editor.setText('Version 1.2.3')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-minor'
      expect(editor.getText()).toEqual('Version 1.3.0')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-minor'
      expect(editor.getText()).toEqual('Version 1.4.0')

    it "should increment patch version", ->
      next = Numbers.incrementPatch '1.2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 1, minor: 2, patch: 4})
      next = Numbers.incrementPatch '2.3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 2, minor: 3, patch: 1})
      next = Numbers.incrementPatch '3'
      ver = Numbers.getSemVerParts next
      expect(ver).toEqual({major: 3, minor: 0, patch: 1})

    it "should increment patch version of selected text", ->
      editor.setText('Version 1.2.3')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-patch'
      expect(editor.getText()).toEqual('Version 1.2.4')
      editor.setCursorScreenPosition([0,8])
      editor.selectToScreenPosition([0,13])
      atom.commands.dispatch workspaceElement, 'atom-numbers:increment-patch'
      expect(editor.getText()).toEqual('Version 1.2.5')

    it "should calculate % operations", ->
      expect(Numbers.calculate('20*10%')).toEqual('2')
      expect(Numbers.calculate('20*51%')).toEqual('10.2')

  describe "Calculate", ->
    it "should calculate number operation (+,-,*,/)", ->
      expect(Numbers.calculate "2*2").toEqual('4')
      expect(Numbers.calculate "2*2+9*2-6/2").toEqual('19')
      expect(Numbers.calculate "-2*2-6/2").toEqual('-7')
      expect(Numbers.calculate "-2a*2").toEqual('-4*a')
    it "should calculate selected operations", ->
      editor.setText('1440+60')
      editor.setCursorScreenPosition([0,0])
      editor.selectToScreenPosition([0,7])
      atom.commands.dispatch workspaceElement, 'atom-numbers:calculate'
      expect(editor.getText()).toEqual('1500')
    it "should calculate selected operations", ->
      editor.setText('20*10%')
      editor.setCursorScreenPosition([0,0])
      editor.selectToScreenPosition([0,7])
      atom.commands.dispatch workspaceElement, 'atom-numbers:calculate'
      expect(editor.getText()).toEqual('2')
