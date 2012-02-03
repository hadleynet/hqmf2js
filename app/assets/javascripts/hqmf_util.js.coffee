class TS
  constructor: (hl7ts) ->
    year = parseInt(hl7ts.substring(0, 4))
    month = parseInt(hl7ts.substring(4, 6))-1
    day = parseInt(hl7ts.substring(6, 8))
    @date = new Date(year, month, day)
  add: (pq) ->
    if pq.unit=="a"
      @date.setFullYear(@date.getFullYear()+pq.value)
    else if pq.unit=="mo"
      @date.setMonth(@date.getMonth()+pq.value)
    else if pq.unit=="d"
      @date.setDate(@date.getDate()+pq.value)
    else if pq.unit=="h"
      @date.setHours(@date.getHours()+pq.value)
    else if pq.unit=="min"
      @date.setMinutes(@date.getMinutes()+pq.value)
    else
      throw "Unknown time unit: "+pq.unit
  asDate: ->
    @date
  
class CD
	constructor: (@code) ->
	code: ->
	  @code
	match: (val) ->
	  @code==val
	
class PQ
	constructor: (@value, @unit) ->
	unit: -> @unit
	value: -> @value
	lessThan: (val) ->
	  @value<val
	greaterThan: (val) ->
	  @value>val
	match: (val) ->
	  @value==val
	
class IVL
  constructor: (@low_pq, @high_pq) ->
  match: (val) ->
    (@low_pq==null || @low_pq.lessThan(val)) && (@hight_pq==null || @high_pq.greaterThan(val))
	
atLeastOneTrue = (values...) ->
  trueValues = (value for value in values when value && (value==true || value.length>0))
  trueValues.length>0
  
allTrue = (values...) ->
  trueValues = (value for value in values when value && (value==true || value.length>0))
  trueValues.length==values.length
  
matchingValue = (value, compareTo) ->
  compareTo.match(value)

filterEventsByValue = (events, value) ->
  matchingValues = (event for event in events when (event.value && value.match(event.value().scalar)))
  matchingValues

getCodes = (oid) ->

PREVSUM = (eventList) ->
  eventList

RECENT = (events) ->
  dateSortDescending = (a, b) ->
    b.date.getTime() - a.date.getTime()
  events.sort(dateSortDescending)[0]
  
