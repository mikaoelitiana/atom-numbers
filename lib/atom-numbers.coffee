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

  replaceSelectedWith: (str) ->
    editor = atom.workspace.getActiveTextEditor()
    range = editor.getSelectedBufferRange()
    editor.setTextInBufferRange(range, str)

  increment: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      if isFinite(selectedText) && selectedText != ''
        @replaceSelectedWith((Number(selectedText) + 1).toString())

  decrement: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      if isFinite(selectedText)  && selectedText != ''
        @replaceSelectedWith((Number(selectedText) - 1).toString())

  insertPi: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('3.14159265359')
