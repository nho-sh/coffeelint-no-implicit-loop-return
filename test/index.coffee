assert = require 'assert'
coffeelint = require 'coffeelint'

good_sources =
"""
	->
		true
===
	f5: ->
		f()
		for i in [0..2]
			f()
		return
===
	f6: ->
		f()
		f() for i in [0..2]
		return
===
	f7: -> return ( f() for i in [0..2] )
===
	f1: ->
		f()
		return true
===
	f2: ->
		f()
		true
===
	f12: ->
		for i in [0..1]
			if i == 1
				return i
			else
				return i+1
===
	f12b: ->
		for i in [0..1]
			for i in [0..1]
				if i == 1
					return i
				else
					return i+1
===
	f12c: ->
		for i in [0..1]
			loop
				if i == 1
					return i
				else
					return i+1
===
	f12d: ->
		for i in [0..1]
			i = i
			if true
				if i == 1
					return i
				else
					return i+1
			i = i
""".split('===')

bad_sources =
"""
	->
		f() for [0..2] by 10
===
	f3a: ->
		f()
		for i in [0..2]
			f()
===
	f3b: ->
		f()
		for i in list
			f()
===
	f4: -> f() for i in [0..2]
===
	f4a: -> f() for [0..2]
===
	f4b: ->
		f() for i in [0..2]
===
	f8: ->
		loop
			break
===
	f9: ->
		while true
			break
===
	f10: ->
		for x of {}
			f(x)
===
	f10b: ->
		for own x of {}
			f(x)
===
	f11: ->
		until false
			f(x)
""".split('===')

getErrorsForSource = (source) ->
	return [] if source.trim() == ''
	
	config =
		"no_implicit_loop_return":
			level: 'warn'
			module: './'
	
	errors = coffeelint
		.lint(source, config)
		.filter (error) -> error.rule == "no_implicit_loop_return"
	
	return errors

for source in good_sources
	errors = getErrorsForSource(source)
	assert.ok(errors.length == 0)

for source in bad_sources
	errors = getErrorsForSource(source)
	assert.ok(errors.length != 0)

return
