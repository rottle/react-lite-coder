_ = require 'lodash'
cx = require 'classnames'
CodeMirror = require 'codemirror'
React = require 'react'

T = React.PropTypes

div = React.createFactory 'div'
textarea = React.createFactory 'textarea'

module.exports = React.createClass
  displayName: 'lite-code-editor'

  propTypes:
    readOnly:     T.bool
    option:       T.object
    defaultValue: T.string
    mode:         T.string
    name:         T.string
    theme:        T.string
    onChange:     T.func

  getDefaultProps: ->
    mode:     'null'
    readOnly: false
    theme:    'default'
    defaultOption:
      indentUnit:     2
      indentWithTabs: true
      lineNumbers:    true
      lineWrapping:   true
      placeholder:    'Code goes here...'
      smartIndent:    true
      tabSize:        2

  componentDidMount: ->
    editor = @refs.editor.getDOMNode()
    option = _.assign {},
      @props.defaultOption,
      @props.option,
      { mode: @props.mode },
      { readOnly: @props.readOnly },
      { theme: @props.theme },

    @editor = CodeMirror.fromTextArea editor, option
    @editor.on 'change', @onEditorChange

  componentWillReceiveProps: (nextProps) ->
    if @editor.getOption('mode') isnt nextProps.mode
      @editor.setOption 'mode', nextProps.mode

  onEditorChange: ->
    value = @editor.getValue()
    @props.onChange value

  renderEditor: ->
    textarea
      className:    'editor'
      ref:          'editor'
      readOnly:     @props.readOnly
      defaultValue: @props.defaultValue
      placeholder:  @props.placeholder
      onChange:     @props.onChange


  render: ->
    className = cx 'lite-code-editor',
      "is-for-#{@props.name}": @props.name?

    div className: className,
      @renderEditor()
