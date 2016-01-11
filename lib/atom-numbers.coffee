{CompositeDisposable} = require 'atom'

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

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  replaceSelectedWith: (str, range) ->
    editor = atom.workspace.getActiveTextEditor()
    if !range?
      range = editor.getSelectedBufferRange()
    editor.setTextInBufferRange(range, str)

  increment: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if isFinite(selectedText) && selectedText != ''
          @replaceSelectedWith((Number(selectedText) + 1).toString(), range)

  decrement: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if isFinite(selectedText) && selectedText != ''
          @replaceSelectedWith((Number(selectedText) - 1).toString(), range)

  insertPi: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('3.14159265359')
