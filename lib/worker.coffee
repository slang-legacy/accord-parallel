accord = require 'accord'
JASON = require 'JASON'

# keep a cache of adapters
adapters = {}

module.exports = (adapter, method, args, cb) ->
  unless adapter of adapters
    adapters[adapter] = accord.load(adapter)
  adapters[adapter][method](args...).then(
    (res) ->
      cb null, JASON.stringify(res)
    (err) -> cb err
  )
