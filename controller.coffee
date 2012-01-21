#### Filename: controller.coffee
# 
#### Author: oroce 
#
#### Description: 
# Base controller for [expressjs framework](http://expressjs.com)
#

#### Utility
# This is utility function for extending some objects.

extend = ( obj = {}, options... ) ->
	options.forEach ( option, i ) ->
		for key, prop of option
			if prop != null
				obj[ key ] = prop
	return obj    
	
#### ***Controller***
class Controller
	#### Constructor
	# Constructor, it stores the `app`.
	constructor: ( @app ) ->	
		@delegateRoutes()
		@initialize.apply( this, arguments )
		
	# Routes hash (you can find an example in the [`user`](user.html) controller)
	routes: {}
	
	# The magic happens here.
	delegateRoutes: () ->
		# Iterating through the routes object.
		for key, callback of @routes
			# Splitting the object key 
			parts = key.split " "
			# First part is the method (get,post,put,all,delete)
			method = parts[ 0 ]
			# and the second part is the route.
			route = parts[ 1 ]
			
			# The value of the object stores the method, 
			# which should be called
			_callbacks = callback.split " "
			
			callbacks = _callbacks.map( ( _callback ) ->
				callbackFunc = this[ _callback ]
				# Throw an exception if a callback method isn't a function,
				# it makes the development/debugging much more faster
				throw "callback [#{callback}] should be a function" if typeof callbackFunc isnt "function"
				# We bind the callback to `this`, which in this case means the controller,
				# we have to do this because expressjs changes the context. :(
				return callbackFunc.bind this
				
				# Passing the controller object to `forEach`.
			, @)
			
			# Just debug information about the attached route
			console.log "[route mapping]", method, route
			@app[ method ].apply( 
				@app, [].concat( route, callbacks )
			)
			
	# Initialize method, this is invoked at the end of constructor.
	initialize: () ->
	
	# The default method to check authenticated user.
	checkAuth: ( req, res, next ) ->
		# You should make a db query or sg like that
		# or with PassportJS you can do this:
		#
		#		return next() if req.isAuthenticated()
		
		# If authentication is okay, you can call the `next()` function
		return next() 
		# otherwise you should redirect the user to `/login` with 401 status code.
		res.redirect( "/login", 401 )
	
	# `respondTo` makes our content negotiation, it can be override in every controller.
	#
	# This is a REALLY EXPERIMENTAL STUFF. 
	# It's important to pass `req` and `res` objects to `respondTo`, DO NOT FORGET!
	respondTo: ( options={}, req, res ) ->
		# If `req.is( "json" )` or format parameter is json,
		# we send json data
		isJSON = true if req.is( "json" ) or req.params.format is "json"
		
		return res.json( options.data, options.status || 200 ) if isJSON
		
		# otherwise we send html, but
		options.html ||= {}
		html = extend( options.html, options.data )
		# if request is made via xhr, then we don't want to render the layout.
		html.layout = if req.xhr then false else html.layout
		
		# And finally call the render method.
		return res.render( 
			options.template,
			html
		)
		                                                                                                                          
# Exporting the `Controller` 
module.exports = Controller