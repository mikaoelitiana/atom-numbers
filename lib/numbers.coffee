module.exports = Numbers =

  incrementNumber: (content, delta) ->
    content.replace /(-?\d+(?:\.\d*)?)/g, (match, p1) ->
      Number(p1) + delta

  isSemVer: (ver) ->
    return /^(\d+\.)?(\d+\.)?(\*|\d+)$/.test ver

  getSemVerParts: (ver) ->
    match = ver.match /^(\d+\.)?(\d+\.)?(\*|\d+)$/
    {
      major: if match[1] then parseInt match[1] else if match[3] then parseInt match[3] else 0
      minor: if match[2] then parseInt match[2] else if match[1] and match[3] then parseInt match[3] else 0
      patch: if match[1] and match[2] then parseInt match[3] else 0
    }

  incrementMajor: (ver) ->
    if typeof ver is 'string'
      ver = @getSemVerParts ver
    (ver.major + 1) + '.0.0'

  incrementMinor: (ver) ->
    if typeof ver is 'string'
      ver = @getSemVerParts ver
    ver.major + '.'  + (ver.minor + 1) + '.0'

  incrementPatch: (ver) ->
    if typeof ver is 'string'
      ver = @getSemVerParts ver
    ver.major + '.'  + ver.minor + '.' + (ver.patch + 1)
