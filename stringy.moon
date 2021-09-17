-- stringy.moon
-- SFZILabs 2021

if not NEON
	if not isfile 'neon/init.lua'
		makefolder 'neon'
		raw = 'https://raw.githubusercontent.com/%s/%s/master/init.lua'
		writefile 'neon/init.lua', game\HttpGet raw\format 'belkworks','neon'

	pcall loadfile 'neon/init.lua'
	assert NEON, 'failed to load neon!'

HttpService = game\GetService 'HttpService'
Chalk = NEON\github 'belkworks', 'chalk'

import insert, concat from table

keys = (t) -> [k for k in pairs t]
isArray = (t) -> #t == #keys t
capFirst = (s) -> s\sub(1,1)\upper! .. s\sub 2

stringify = ->

stringifyTable = (t, depth = 0, explored = {}) ->
	me = explored[t]
	explored[t] or= 0
	unexplored = explored[t] == 0
	explored[t] += 1

	if explored[t] > 1
		return Chalk.light.blue "[Circular]"

	array = isArray t
	keylist = keys t
	keysc = #keylist
	brackets = if array
		{'[', ']'}
	else {'{', '}'}

	r = { brackets[1], '\n' }

	depth += 1
	for i, k in pairs keylist
		value = t[k]
		insert r, '    '\rep depth
		if array
			insert r, stringify value, depth, explored
			insert r, ', ' if i < keysc
		else
			k = stringify k, depth, explored
			v = stringify value, depth, explored
			if count = explored[value]
				if explored[t] + 1 == count
					k ..= Chalk.light.cyan " <ref>"

			insert r, k .. ': ' .. v

		insert r, '\n'

	insert r, '    '\rep depth - 1
	insert r, brackets[2]

	concat r, ''

stringify = (any, ...) ->
	switch type any
		when 'string'
			Chalk.green HttpService\JSONEncode any
		when 'boolean', 'number'
			Chalk.yellow any
		when 'table'
			stringifyTable any, ...
		when 'function'
			Chalk.light.blue "[#{capFirst tostring any}]"
		when 'userdata'
			Chalk.light.cyan if typeof
				t = typeof any
				if t != 'userdata'
					"#{t} #{any}"
				else any
			else any

		when 'vector'
			"Vector3(#{Chalk.yellow any})"

		else Cyan.light.red any

(...) ->
	Chalk.print unpack [stringify v for v in *{...}]
