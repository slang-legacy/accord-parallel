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
    if not _.isEqual(args, (args2 = JSON.parse(JSON.stringify(args))))
      canBeDelegated = false
      console.log 'cant be delegated', args, args2
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
    @compile = @_delegate.bind(this, 'compile')
    @compileFile = @_delegate.bind(this, 'compileFile')
    @compileClient = @_delegate.bind(this, 'compileClient')
    @compileFileClient = @_delegate.bind(this, 'compileFileClient')

module.exports.load = (name) -> new AccordProxy(name)
module.exports.supports = accord.supports
module.exports.all = accord.all
