{CompositeDisposable} = require 'atom'
Numbers = require './numbers'

module.exports = AtomNumbers =
  modalPanel: null
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands for Numbers
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-numbers:increment': => @increment()
      'atom-numbers:decrement': => @decrement()
      'atom-numbers:pi': => @insertPi()
      'atom-numbers:increment-major': => @incrementMajor()
      'atom-numbers:increment-minor': => @incrementMinor()
      'atom-numbers:increment-patch': => @incrementPatch()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  replaceSelectedWith: (str, range) ->
    editor = atom.workspace.getActiveTextEditor()
    if !range?
      range = editor.getSelectedBufferRange()
    editor.setTextInBufferRange(range, str)

  addToSelection: (delta) ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if selectedText != ''
          @replaceSelectedWith(Numbers.incrementNumber(selectedText, delta).toString(), range)

  increment: ->
    @addToSelection 1

  decrement: ->
    @addToSelection -1

  insertPi: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('3.14159265359')

  incrementSelection: (part) ->
    switch part
      when 'major'
        func = Numbers.incrementMajor
      when 'minor'
        func = Numbers.incrementMinor
      when 'patch'
        func = Numbers.incrementPatch
      else
        null
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if Numbers.isSemVer(selectedText) && selectedText != ''
          ver = Numbers.getSemVerParts selectedText
          console.log ver
          @replaceSelectedWith(func(ver), range)

  incrementMajor: ->
    @incrementSelection 'major'

  incrementMinor: ->
    @incrementSelection 'minor'

  incrementPatch: () ->
    @incrementSelection 'patch'
