AtomNumbersView = require './atom-numbers-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomNumbers =
  atomNumbersView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomNumbersView = new AtomNumbersView(state.atomNumbersViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomNumbersView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands for Numbers
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-numbers:increment': => @increment()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-numbers:decrement': => @decrement()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomNumbersView.destroy()

  serialize: ->
    atomNumbersViewState: @atomNumbersView.serialize()

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
