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

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  increment: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      if isFinite selectedText
        incrementedValue = Number(selectedText) + 1
        range = editor.getSelectedBufferRange()
        editor.setTextInBufferRange(range, incrementedValue.toString())

  decrement: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      if isFinite selectedText
        incrementedValue = Number(selectedText) - 1
        range = editor.getSelectedBufferRange()
        editor.setTextInBufferRange(range, incrementedValue.toString())
