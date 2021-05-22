module.exports = class NoImplicitLoopReturn
	
	rule:
		name: 'no_implicit_loop_return'
		level: 'error'
		message: 'Explicity return loop results for function that end with a loop'
		description: require('./package.json').description
	
	lintAST: (node, @astApi) ->
		@lintNode node
		undefined
	
	lintNode: (node) ->
		if @isCode(node) and @endsWithLoop(node)
			error = @astApi.createError
				lineNumber: node.locationData.first_line + 1
			@errors.push error
		
		node.eachChild (child) => @lintNode child
	
	isCode: (node) -> @astApi.getNodeName(node) is 'Code'
	
	isLoop: (type) -> type is 'For' or type is 'While'
	
	endsWithLoop: (node) ->
		# Get the last expression in a code block
		[..., lastExp] = node.body.expressions
		
		if lastExp && @isLoop(@astApi.getNodeName(lastExp)) && !@returnInLoop(lastExp)
			return true
		
		return false
	
	returnInLoop: (node) =>
		node.body?.contains((child) =>
			if @astApi.getNodeName(child) in [ 'If', 'For', 'While' ]
				return @returnInLoop(child)
			else if child.astType() == 'ReturnStatement'
				return true
			else
				return false)?
