###
The MIT License

Copyright (c) 2015 Michalis Korakakis, Inc. https://github.com/mkorakakis.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

###*
# @module drivelist-scanner
###

EventEmitter = require('events').EventEmitter
_ = require('lodash')
Promise = require('bluebird')
drivelist = Promise.promisifyAll(require('drivelist'))
compare = require('./compare')

module.exports = class DrivelistScanner extends EventEmitter

	###*
	# @summary Detect changes in drive list
	# @class
	# @name DrivelistScanner
	# @extends external:EventEmitter
	# @protected
	#
	# @param {Object} [options] - scan options
	# @param {Number} [options.interval=1000] - check interval
	# @param {Object[]} [options.drives] - available drives during initialization
	#
	# @emits module:drivelist-scanner~DrivelistScanner#add
	# @emits module:drivelist-scanner~DrivelistScanner#remove
	#
	# @example
	# scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])
	#
	# scanner.on 'add', (drives) ->
	# 	console.log drives
	#
	# scanner.on 'remove', (drives) ->
	# 	console.log drives
	###
	constructor: (options = {}) ->
		super()

		_.defaults options,
			interval: 1000,
			drives: []

		@drives = options.drives

		@interval = setInterval =>
			@scan()
		, options.interval

		@scan()

	###*
	# @summary Fires events when a drive has been added/removed
	# @method
	# @private
	#
	# @example
	# scanner = new DrivelistScanner(interval: 1000)
	# scanner.scan(driveFinder)
	###
	scan: ->
		DrivelistScanner.getDrives().then (drives) =>

			comparison = compare(@drives, drives)
			@drives = comparison.drives

			_.each comparison.diff, (operation) =>
				if operation.type is 'add'

					###*
					# Fired on new drive addition.
					#
					# @event module:drivelist-scanner~DrivelistScanner#add
					# @type {Object}
					# @property {Object[]} drives - Contains the drives that have been added.
					###
					@emit('add', operation.drive)
				else if operation.type is 'remove'

					###*
					# Fired when a pre-existing drive has been removed.
					#
					# @event module:drivelist-scanner~DrivelistScanner#remove
					# @type {Object}
					# @property {Object[]} drives - Contains the drives that have been removed.
					###
					@emit('remove', operation.drive)
				else
					throw Error("Unknown operation: #{operation.type}")

	###*
	# @summary List all available drives
	# @method
	# @static
	#
	# @fulfil {Object[]} - available drives
	# @returns {Promise}
	#
	# @example
	# DrivelistScanner.getDrives().then (drives) ->
	# 	console.log(drives)
	###
	@getDrives: ->
		drivelist.listAsync().then (drives) ->
			return _.reject(drives, system: true)

	###*
	# @summary Stop the check interval
	# @method
	# @public
	#
	# @throws Will throw if the interval id is not valid.
	#
	# @example
	# scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])
	# scanner.stop()
	###
	stop: ->
		if not @interval?
			throw new Error('Can\'t stop interval. Are you calling stop() with the right context?')
		clearInterval(@interval)

###*
@external EventEmitter
@see http://nodejs.org/api/events.html
###
