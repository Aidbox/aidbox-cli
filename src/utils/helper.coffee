cli   = require 'cli'
Table = require 'cli-table'

chars = { 'top': '' , 'top-mid': '' , 'top-left': '' , 'top-right': '' , 'bottom': '' , 'bottom-mid': '' , 'bottom-left': '' , 'bottom-right': '' , 'left': '' , 'left-mid': '' , 'mid': '' , 'mid-mid': '' , 'right': '' , 'right-mid': '' , 'middle': '|'}

tablePrint = (table)->
  console.log ''
  console.log table.toString()
  console.log ''

boxTableFill = (data)->
  table = new Table
    chars: chars
    head: ['ID', 'Host', 'Created']
    colWidths: [15, 50, 30]
  data.map((entry)-> table.push( [entry.id, entry.host, entry.created_at]))
  table

userTableFill = (data)->
  table = new Table
    chars: chars
    head: ['ID', 'Email']
    colWidths: [5, 50]
  data.map((entry)-> table.push( [entry.id, entry.email]))
  table

boxTable = (data)->
  tablePrint(boxTableFill (data))

userTable = (data)->
  tablePrint(userTableFill (data))

errHandler = (e)->
  cli.error 'Problem with request: ' + e.message

catchError = (data, res, cb)->
  if res.statusCode == 403
    cli.error 'Access deny'
    return
  if data instanceof Error
    cli.error data.message
    cli.error data
  else
    cb(data)

module.exports =
  boxTable: boxTable
  userTable: userTable
  errHandler: errHandler
  catchError: catchError



