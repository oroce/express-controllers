#### Filename: controller.coffee
# 
#### Author: oroce 
#
#### Description: 
# User controller for [expressjs framework](http://expressjs.com)
#

# We require the [base controller](controller.html)

Controller = require "./controller"

class UserController extends Controller
	# Routes object
	routes:
		"get /":                  "getIndex"
		"all /user/:id.:format?": "userExists"
		"get /user/:id.:format?": "checkAuth beforeGetById getById"
		"get /users":             "getUsers"
	
	# Our initialize method
	initialize: () ->
		# For example here you can cache the [mongoose](http://mongoosejs.com) objects
		#
		#		@UserModel = @app.db.model( "User" )
		
	# `getUsers` method, for listing users.
	getUsers: ( req, res ) ->
		@respondTo(
			html: 
				layout: "foo/bar"
				template: "default"
			data: {users: [{"id": "1"}]}
			status: 200
			req,
			res
		)
		
	# Just an index method,
	getIndex: ( req, res, next ) ->
		res.send( "index" );
	
	# This is just a dummy method, to understand the whole logic.
	beforeGetById: ( req, res, next ) ->
		console.log "beforeGetById"
		# At the end we call `next()` to go further.
		next()
	
	# 'private-like' method
	#
	# You can query the db for checking user existance.
	_userExists: ( id ) ->
		ret = false
		if +id is 1
			ret =
				userId: id
				userProp: "userValue"
		# It returns `false` or an abject, which stores the user information.
		return ret
	
	# `userExists` method
	userExists: ( req, res, next ) ->
		# Calling `_userExists` method.
		userInfo = @_userExists( req.params.id )
		
		# We store the user informations in `req.userInfo` object the next method(s).
		req.userInfo = userInfo
		
		# And calling `next()` if userInfo isn't false.
		return next() if userInfo
		
		# User was not found, so show an error page to the user, or send some json with 404 status code.
		#
		# If you would like you can throw exception i prefer show an error page.
		@respondTo(
			data:
				error: "USER_NOT_FOUND"
			html:
				layout: "layouts/notfound"
				template: "user/notfound"
			status: 404
			req, res
		)
	
	# The `getById` method, which is invoked `userExists` and `beforeGetById` methods.
	getById: ( req, res, next ) ->
		# Getting user information from `req.userInfo` object.
		responseData = req.userInfo
		# Send information as a json, or html.
		@respondTo(
			data: responseData
			status: 200
			json: true,
			req,res
		)
	
module.exports = UserController