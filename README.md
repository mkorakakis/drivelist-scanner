drivelist-scanner
=================

[![npm version](https://badge.fury.io/js/drivelist-scanner.svg)](http://badge.fury.io/js/drivelist-scanner)
[![dependencies](https://david-dm.org/mkorakakis/drivelist-scanner.png)](https://david-dm.org/mkorakakis/drivelist-scanner.png)
[![Build Status](https://travis-ci.org/mkorakakis/drivelist-scanner.svg?branch=master)](https://travis-ci.org/mkorakakis/drivelist-scanner)
[![Build status](https://ci.appveyor.com/api/projects/status/dljdbst05bp29wgv?svg=true)](https://ci.appveyor.com/project/mkorakakis/drivelist-scanner)

Dynamically detect when drives are being added and/or removed.

Installation
------------

Install `drivelist-scanner` by running:

```sh
$ npm install --save drivelist-scanner
```

Documentation
-------------


* [drivelist-scanner](#module_drivelist-scanner)
  * [~DrivelistScanner](#module_drivelist-scanner..DrivelistScanner) ⇐ <code>[EventEmitter](http://nodejs.org/api/events.html)</code>
    * [new DrivelistScanner([options])](#new_module_drivelist-scanner..DrivelistScanner_new)
    * _instance_
      * [.stop()](#module_drivelist-scanner..DrivelistScanner+stop)
      * ["add"](#module_drivelist-scanner..DrivelistScanner+event_add)
      * ["remove"](#module_drivelist-scanner..DrivelistScanner+event_remove)
    * _static_
      * [.getDrives()](#module_drivelist-scanner..DrivelistScanner.getDrives) ⇒ <code>Promise</code>

<a name="module_drivelist-scanner..DrivelistScanner"></a>
### drivelist-scanner~DrivelistScanner ⇐ <code>[EventEmitter](http://nodejs.org/api/events.html)</code>
**Kind**: inner class of <code>[drivelist-scanner](#module_drivelist-scanner)</code>  
**Summary**: Detect changes in drive list  
**Extends:** <code>[EventEmitter](http://nodejs.org/api/events.html)</code>  
**Emits**: <code>[add](#module_drivelist-scanner..DrivelistScanner+event_add)</code>, <code>[remove](#module_drivelist-scanner..DrivelistScanner+event_remove)</code>  
**Access:** protected  

* [~DrivelistScanner](#module_drivelist-scanner..DrivelistScanner) ⇐ <code>[EventEmitter](http://nodejs.org/api/events.html)</code>
  * [new DrivelistScanner([options])](#new_module_drivelist-scanner..DrivelistScanner_new)
  * _instance_
    * [.stop()](#module_drivelist-scanner..DrivelistScanner+stop)
    * ["add"](#module_drivelist-scanner..DrivelistScanner+event_add)
    * ["remove"](#module_drivelist-scanner..DrivelistScanner+event_remove)
  * _static_
    * [.getDrives()](#module_drivelist-scanner..DrivelistScanner.getDrives) ⇒ <code>Promise</code>

<a name="new_module_drivelist-scanner..DrivelistScanner_new"></a>
#### new DrivelistScanner([options])

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [options] | <code>Object</code> |  | scan options |
| [options.interval] | <code>Number</code> | <code>1000</code> | check interval |
| [options.drives] | <code>Array.&lt;Object&gt;</code> |  | available drives during initialization |

**Example**  
```js
scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])

scanner.on 'add', (drives) ->
	console.log drives

scanner.on 'remove', (drives) ->
	console.log drives
```
<a name="module_drivelist-scanner..DrivelistScanner+stop"></a>
#### drivelistScanner.stop()
**Kind**: instance method of <code>[DrivelistScanner](#module_drivelist-scanner..DrivelistScanner)</code>  
**Summary**: Stop the check interval  
**Throws**:

- Will throw if the interval id is not valid.

**Access:** public  
**Example**  
```js
scanner = new DrivelistScanner(interval: 1000, drives: [ { foo: 'bar' } ])
scanner.stop()
```
<a name="module_drivelist-scanner..DrivelistScanner+event_add"></a>
#### "add"
Fired on new drive addition.

**Kind**: event emitted by <code>[DrivelistScanner](#module_drivelist-scanner..DrivelistScanner)</code>  
**Properties**

| Name | Type | Description |
| --- | --- | --- |
| drives | <code>Array.&lt;Object&gt;</code> | Contains the drives that have been added. |

<a name="module_drivelist-scanner..DrivelistScanner+event_remove"></a>
#### "remove"
Fired when a pre-existing drive has been removed.

**Kind**: event emitted by <code>[DrivelistScanner](#module_drivelist-scanner..DrivelistScanner)</code>  
**Properties**

| Name | Type | Description |
| --- | --- | --- |
| drives | <code>Array.&lt;Object&gt;</code> | Contains the drives that have been removed. |

<a name="module_drivelist-scanner..DrivelistScanner.getDrives"></a>
#### DrivelistScanner.getDrives() ⇒ <code>Promise</code>
**Kind**: static method of <code>[DrivelistScanner](#module_drivelist-scanner..DrivelistScanner)</code>  
**Summary**: List all available drives  
**Fulfil**: <code>Object[]</code> - available drives  
**Example**  
```js
DrivelistScanner.getDrives().then (drives) ->
	console.log(drives)
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/mkorakakis/drivelist-scanner/issues/new) on GitHub andand I'll be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/mkorakakis/drivelist-scanner/issues](https://github.com/mkorakakis/drivelist-scanner/issues)
- Source Code: [github.com/mkorakakis/drivelist-scanner](https://github.com/mkorakakis/drivelist-scanner)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the MIT license.
