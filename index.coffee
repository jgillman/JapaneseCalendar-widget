# Japanese Calendar

command: "/usr/local/bin/calja"

#Set this to true to enable previous and next month dates, or false to disable
otherMonths: true

refreshFrequency: 3600000

style: """
  bottom: 10px
  left: 10px
  color: #fff
  font-family: Helvetica

  table
    border-collapse: collapse
    table-layout: fixed

  td
    text-align: center
    padding: 4px 6px
    text-shadow: 0 0 1px rgba(#000, 0.5)

  thead tr
    &:first-child td
      font-size: 20px
      font-weight: 100%

    &:last-child td
      font-size: 11px
      padding-bottom: 5px
      font-weight: 100%

  tbody td
    font-size: 15px

  .today
    font-weight: bold
    background: rgba(#f00, 0.5)
    border-radius: 50%

  .grey
    color: rgba(#00A0F0, .7)
"""

render: -> """
  <table>
    <thead>
    </thead>
    <tbody>
    </tbody>
  </table>
"""


updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  #Set to 1 to enable previous and next month dates, 0 to disable
  PrevAndNext = 1

  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()

  #today = rows.pop().split(/\s+/)
  today = today = new Date
  month = today.getMonth()+1
  date = today.getDate()
  year = today.getFullYear()

  lengths = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
  if year%4 == 0
    lengths[2] = 29

  for week, i in rows
    days = week.split(/\s+/).filter (day) -> day.length > 0
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        if @otherMonths == true
          k = 6 - j
          cell = $("<td>#{lengths[month-1]-k}</td>").appendTo(tableRow)
          cell.addClass("grey")
        else
          cell = $("<td></td>").appendTo(tableRow)

    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day.toString() == date.toString()

    if i != 0 and 0 < days.length < 7 and @otherMonths == true
      for j in [1..7-days.length]
        cell = $("<td>#{j}</td>").appendTo(tableRow)
        cell.addClass("grey")

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table
