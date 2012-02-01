class TS
  constructor: (@hl7ts) ->
  add: (pq) ->
  
class CD
	constructor: (@code) ->
	
class PQ
	constructor: (@value, @unit) ->
	unit: -> @unit
	value: -> @value
	
anyTrue = (values...) ->
  trueValues = (value for value in values when value==true || value.length>0)
  trueValues.length>0