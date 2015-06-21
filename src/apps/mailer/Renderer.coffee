_         = require 'lodash'
glob      = require 'glob'
fs        = require 'fs'
path      = require 'path'
html2text = require 'html-to-text'
juice     = require 'juice'
swig      = require 'swig'
stylus    = require 'stylus'
yaml      = require 'yamljs'
Email     = require './Email'

class Renderer

  constructor: (@log, @config) ->
    root = path.resolve(__dirname, 'templates')
    @styles = @loadStyles(root)
    @templates = @compileTemplates(root)
    @log.debug "Compiled #{_.size(@templates)} templates"

  render: (request) ->

    template = @templates[request.type]
    unless template?
      throw new Error("Don't know how to render an email of type #{request.type}")

    vars = template.renderVars(request.params)
    html = template.renderBody(request.params)
    text = html2text.fromString(html)

    email =
      type:    request.type
      params:  request.params
      from:    vars.from
      subject: vars.subject
      to:      _.flatten [request.to]
      cc:      _.flatten [request.cc]   if request.cc?
      bcc:     _.flatten [request.bcc]  if request.bcc?
      replyTo: _.flatten [vars.replyTo] if vars.replyTo?
      html:    html
      text:    text

    return email

  loadStyles: (root) ->
    files = glob.sync('**/*.styl', {cwd: root})
    css = _.map files, (file) ->
      styl = fs.readFileSync(path.resolve(root, file), 'utf8')
      stylus.render(styl, {filename: file})
    return css.join('')

  compileTemplates: (root) ->

    files = glob.sync('**/_*.html', {cwd: root})
    for file in files
      filename = path.resolve(root, file)
      content  = fs.readFileSync(filename, 'utf8')
      swig.compile(juice.inlineContent(content, @styles), {filename})

    files = glob.sync('**/[!_]*.html', {cwd: root})
    return _.object _.map files, (file) =>
      filename = path.resolve(root, file)
      content  = fs.readFileSync(filename, 'utf8')
      template = @createTemplate(content, filename)
      [path.basename(file, '.html'), template]

  createTemplate: (content, filename) ->

    [vars, body] = content.split('---', 2)
    html = juice.inlineContent(body, @styles)

    varsFunc = swig.compile(vars)
    bodyFunc = swig.compile(html, {filename})

    return {
      renderBody: bodyFunc
      renderVars: (params) -> yaml.parse(varsFunc(params))
    }

module.exports = Renderer
