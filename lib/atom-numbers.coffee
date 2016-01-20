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

  addToSelection: (delta) ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if isFinite(selectedText) && selectedText != ''
          @replaceSelectedWith((Number(selectedText) + delta).toString(), range)

  increment: ->
    @addToSelection 1

  decrement: ->
    @addToSelection -1

  insertPi: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('3.14159265359')

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
    if typeof ver is 'string'
      ver = @_getSemVerParts ver
    (ver.major + 1) + '.0.0'

  _incrementMinor: (ver) ->
    if typeof ver is 'string'
      ver = @_getSemVerParts ver
    ver.major + '.'  + (ver.minor + 1) + '.0'

  _incrementPatch: (ver) ->
    if typeof ver is 'string'
      ver = @_getSemVerParts ver
    ver.major + '.'  + ver.minor + '.' + (ver.patch + 1)

  incrementSelection: (part) ->
    switch part
      when 'major'
        func = @_incrementMajor
      when 'minor'
        func = @_incrementMinor
      when 'patch'
        func = @_incrementPatch
      else
        null
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedBufferRanges()
      for range in selection
        selectedText = editor.getTextInBufferRange(range)
        if @_isSemVer(selectedText) && selectedText != ''
          ver = @_getSemVerParts selectedText
          console.log ver
          @replaceSelectedWith(func(ver), range)

  incrementMajor: ->
    @incrementSelection 'major'

  incrementMinor: ->
    @incrementSelection 'minor'

  incrementPatch: () ->
    @incrementSelection 'patch'
