path = require 'path'
cons = require 'consolidate'

module.exports = (env, callback) ->

  class ConsolidateTemplate extends env.TemplatePlugin

    constructor: (@path, @engine='jade') ->

    render: (locals, callback) ->

      # use engine config
      opts = env.config[@engine] || {}
      # enable caching of templates
      opts.cache = true

      for key, val of locals
        opts[key] = val

      cons[@engine] @path, opts, (err, str) ->
        if err then return callback err
        callback null, new Buffer str

  ConsolidateTemplate.fromFile = (filepath, callback) ->
    
    engine = path
      .extname(filepath.full)
      .substring(1)

    callback null, new this filepath.full, engine

  # supported consolidate engines
  exts = Object.keys(cons).join(',')

  env.registerTemplatePlugin "**/*.{#{exts}}", ConsolidateTemplate
  callback()
