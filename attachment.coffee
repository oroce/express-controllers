#### Filename: attachment.coffee
# 
#### Author: oroce 
#
#### Description: 
# Attachment controller for [expressjs framework](http://expressjs.com)
#

# We require the [user controller](user.html)
# 
# Attachment Controller extends the User Controller, which extends the Base Controller

UserController = require "./user"

class AttachmentController extends UserController
	# We have two routes, one for all requests, and one for get request.
	routes:
		"all /user/:id/attachment/:aid.:format?": "userExists attachmentExists"
		"get /user/:id/attachment/:aid.:format?": "getById"
	
	initialize: () ->
	
	# If you don't override the `userExists` method you can inherit from the `UserController`.
	# Now we are okay with the inherited version.
	___userExists: ( req, res, next ) ->
		isUserExists = @_userExists( req.params.id )
		
		return next() if isUserExists
		#if you would like you can throw exception i prefer show an error page
		@respondTo(
			data:
				error: "USER_NOT_FOUND"
			html:
				layout: "layouts/notfound"
				template: "user/notfound"
			json: true
			status: 404
			req, res
		)
	
	# `_attachmentExists` method works like _userExists.
	_attachmentExists: ( id ) ->
		ret = false
		if +id is 1
			ret =
				attachmentId: id
				attachmentProp: "attachmentValue"
		# It returns `false` or an abject, which stores the user information,
		return ret
	
	# `attachmentExists` is like `userExists` method.
	attachmentExists: ( req, res, next ) ->
		
		attachmentInfo = @_attachmentExists( req.params.aid )
		
		# Storing infos for `next()`.
		req.attachmentInfo = attachmentInfo
		
		
		return next() if attachmentInfo
		#If you would like you can throw exception i prefer show an error page.
		@respondTo(
			data:
				error: "ATTACHMENT_NOT_FOUND"
			html:
				layout: "layouts/notfound"
				template: "attachment/notfound"
			json: true
			status: 404
			req, res
		)
	
	# The `getById` which calls the renderer.
	getById: ( req, res ) ->
		
		@respondTo(
			data: 
				userInfo: req.userInfo
				attachmentInfo: req.attachmentInfo
			html:
				layout: false
			json: true
			status: 200
			req, res
		)
		
module.exports = AttachmentController