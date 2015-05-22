# depends on id property containing a 36 base encoded string 
# which represents the createdAt time as seconds since epoch
getCreatedAtFromId = ->
  return if !_.isString(id)
  idRandomStringCharacters = 3
  seconds = parseInt(id.slice(0,-idRandomStringCharacters), 36)
  new Date(seconds) if seconds and seconds > 0

module.exports =

  moduleName: "ooRecordsInstanceMethods"

  afterInitialise: (props) ->
    @createdAt = getCreatedAtFromId(props.id) if _.has(props, 'id')

  save: ->
    _class = @constructor
    if !_class or !_class.hasOwnProperty('update') or !_class.hasOwnProperty('create')
      throw new Error "Class methods for saving not accessible"
    if !@properties
      throw new Error "this.properties not defined"
    if @id
      _class.update(@id, @properties)
    else
      _class.create(@properties)

