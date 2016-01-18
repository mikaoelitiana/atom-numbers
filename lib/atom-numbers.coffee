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

  incrementMajor: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if @_isSemVer(selectedText) && selectedText != ''
          @replaceSelectedWith(@_incrementMajor(selectedText), range)

  _isSemVer: (ver) ->
    return /^(\d+\.)?(\d+\.)?(\*|\d+)$/.test ver

  _getSemVerParts: (ver) ->
    match = ver.match /^(\d+\.)?(\d+\.)?(\*|\d+)$/
    {
      major: if match[1] then parseInt match[1] else if match[3] then parseInt match[3] else 0
      minor: if match[2] then parseInt match[2] else if match[1] and match[3] then parseInt match[3] else 0
      patch: if match[1] and match[2] then parseInt match[3] else 0
    }

  _incrementMajor: (ver) ->
    current = @_getSemVerParts ver
    (current.major + 1) + '.0.0'
