JASON = require 'JASON'
_ = require 'lodash'
nodefn = require 'when/node'
accord = require 'accord'
workerFarm = require 'worker-farm'
workers = workerFarm(require.resolve('./worker'))

class AccordProxy
  _adapter: undefined
  name: ''
  extensions: undefined
  output: undefined
  compiler: undefined

  _delegate: (method, args...) ->
    canBeDelegated = true
    if not _.isEqual(args, JSON.parse(JSON.stringify(args)))
      canBeDelegated = false
    if canBeDelegated
      nodefn.apply(workers, [@name, method, args]).then((res) ->
        JASON.parse(res)
      )
    else
      @_adapter[method](args...)

  constructor: (@name) ->
    @_adapter = accord.load @name
    @extensions = @_adapter.extensions
    @output = @_adapter.output
    @compiler = @_adapter.compiler
    @clientHelpers = @_adapter.clientHelpers
    @render = @_delegate.bind(this, 'render')
    @renderFile = @_delegate.bind(this, 'renderFile')
    @compileClient = @_delegate.bind(this, 'compileClient')
    @compileFileClient = @_delegate.bind(this, 'compileFileClient')

    # these can't be delegated yet because they return functions
    @compile = @_adapter.compile.bind(@_adapter)
    @compileFile = @_adapter.compileFile.bind(@_adapter)

module.exports.load = (name) -> new AccordProxy(name)
module.exports.supports = accord.supports
module.exports.all = accord.all
