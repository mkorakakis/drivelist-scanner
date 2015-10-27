
/*
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
 */

/**
 * @module drivelist-scanner
 */
var DrivelistScanner, EventEmitter, Promise, compare, drivelist, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

EventEmitter = require('events').EventEmitter;

_ = require('lodash');

Promise = require('bluebird');

drivelist = Promise.promisifyAll(require('drivelist'));

compare = require('./compare');

module.exports = DrivelistScanner = (function(_super) {
  __extends(DrivelistScanner, _super);


  /**
  	 * @summary Detect changes in drive list
  	 * @class
  	 * @name DrivelistScanner
  	 * @extends external:EventEmitter
  	 * @protected
  	 *
  	 * @param {Object} [options] - scan options
  	 * @param {Number} [options.interval=1000] - check interval
  	 * @param {Object[]} [options.drives] - available drives during initialization
  	 *
  	 * @emits module:drivelist-scanner~DrivelistScanner#add
  	 * @emits module:drivelist-scanner~DrivelistScanner#remove
  	 *
  	 * @example
  	 * scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])
  	 *
  	 * scanner.on 'add', (drives) ->
  	 * 	console.log drives
  	 *
  	 * scanner.on 'remove', (drives) ->
  	 * 	console.log drives
   */

  function DrivelistScanner(options) {
    if (options == null) {
      options = {};
    }
    DrivelistScanner.__super__.constructor.call(this);
    _.defaults(options, {
      interval: 1000,
      drives: []
    });
    this.drives = options.drives;
    this.interval = setInterval((function(_this) {
      return function() {
        return _this.scan();
      };
    })(this), options.interval);
    this.scan();
  }


  /**
  	 * @summary Fires events when a drive has been added/removed
  	 * @method
  	 * @private
  	 *
  	 * @example
  	 * scanner = new DrivelistScanner(interval: 1000)
  	 * scanner.scan(driveFinder)
   */

  DrivelistScanner.prototype.scan = function() {
    return DrivelistScanner.getDrives().then((function(_this) {
      return function(drives) {
        var comparison;
        comparison = compare(_this.drives, drives);
        _this.drives = comparison.drives;
        return _.each(comparison.diff, function(operation) {
          if (operation.type === 'add') {

            /**
            					 * Fired on new drive addition.
            					 *
            					 * @event module:drivelist-scanner~DrivelistScanner#add
            					 * @type {Object}
            					 * @property {Object[]} drives - Contains the drives that have been added.
             */
            return _this.emit('add', operation.drive);
          } else if (operation.type === 'remove') {

            /**
            					 * Fired when a pre-existing drive has been removed.
            					 *
            					 * @event module:drivelist-scanner~DrivelistScanner#remove
            					 * @type {Object}
            					 * @property {Object[]} drives - Contains the drives that have been removed.
             */
            return _this.emit('remove', operation.drive);
          } else {
            throw Error("Unknown operation: " + operation.type);
          }
        });
      };
    })(this));
  };


  /**
  	 * @summary List all available drives
  	 * @method
  	 * @static
  	 *
  	 * @fulfil {Object[]} - available drives
  	 * @returns {Promise}
  	 *
  	 * @example
  	 * DrivelistScanner.getDrives().then (drives) ->
  	 * 	console.log(drives)
   */

  DrivelistScanner.getDrives = function() {
    return drivelist.listAsync().then(function(drives) {
      return _.reject(drives, {
        system: true
      });
    });
  };


  /**
  	 * @summary Stop the check interval
  	 * @method
  	 * @public
  	 *
  	 * @throws Will throw if the interval id is not valid.
  	 *
  	 * @example
  	 * scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])
  	 * scanner.stop()
   */

  DrivelistScanner.prototype.stop = function() {
    if (this.interval == null) {
      throw new Error('Can\'t stop interval. Are you calling stop() with the right context?');
    }
    return clearInterval(this.interval);
  };

  return DrivelistScanner;

})(EventEmitter);


/**
@external EventEmitter
@see http://nodejs.org/api/events.html
 */
