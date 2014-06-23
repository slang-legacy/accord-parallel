accord = require 'accord'

# keep a cache of adapters
adapters = {}

module.exports = (adapter, customPath, method, args, cb) ->
  unless adapter of adapters
    adapters[adapter] = accord.load(adapter, customPath)
  adapters[adapter][method](args...).then(
    (res) ->
      cb null, JSON.stringify(res)
    (err) -> cb err
  )
