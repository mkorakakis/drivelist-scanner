m = require('mochainon')
_ = require('lodash')
Promise = require('bluebird')
drivelist = require('drivelist')
DrivelistScanner = require('../lib/drivelist-scanner')

describe 'Drive Scanner:', ->

	describe 'given pre-populated drive options', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([ { foo: 'bar' } ]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should cause the drives class property to contain the same pre-existing drives', ->
			scanner = new DrivelistScanner(interval: 100, drives: [ { foo: 'bar' } ])
			m.chai.expect(scanner.drives).to.deep.equal([ { foo: 'bar' } ])
			scanner.stop()

	describe 'given no pre-existing drive options', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should cause the drives class property to be empty', ->
			scanner = new DrivelistScanner(interval: 100, drives: [])
			m.chai.expect(scanner.drives).to.deep.equal([])
			scanner.stop()

	describe 'given a driveFinder that finds one drive that has been added', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([ { foo: 'bar' } ]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should emit a single add event', (done) ->
			scanner = new DrivelistScanner(interval: 100)
			removeSpy = m.sinon.spy()
			m.chai.expect(removeSpy).to.not.have.been.called
			scanner.on 'add', (drive) ->
				m.chai.expect(scanner.drives).to.deep.equal([ { foo: 'bar' } ])
				m.chai.expect(drive).to.deep.equal(foo: 'bar')
				scanner.stop()
				done()

	describe 'given a driveFinder that finds one drive that has been removed', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should emit a single remove event', (done) ->
			scanner = new DrivelistScanner(interval: 100, drives: [ { foo: 'bar' } ])
			addSpy = m.sinon.spy()
			m.chai.expect(addSpy).to.not.have.been.called
			scanner.on 'remove', (drive) ->
				m.chai.expect(scanner.drives).to.deep.equal([])
				m.chai.expect(drive).to.deep.equal(foo: 'bar')
				scanner.stop()
				done()

	describe 'given a driveFinder that finds one drive that has been changed', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.onFirstCall().returns(Promise.resolve([ { foo: 'bar' } ]))
			@getDrivesStub.returns(Promise.resolve([ { foo: 'baz' } ]))


		afterEach ->
			@getDrivesStub.restore()

		it 'should emit a remove and an add event', (done) ->
			scanner = new DrivelistScanner(interval: 100)
			removeSpy = m.sinon.spy()
			scanner.on('remove', removeSpy)
			addSpy = m.sinon.spy()
			scanner.on('add', addSpy)
			setTimeout ->
				m.chai.expect(removeSpy).to.have.been.calledWith(foo: 'bar')
				m.chai.expect(addSpy).to.have.been.calledWith(foo: 'baz')
				scanner.stop()
				done()
			, 500

	describe 'given that no addition/removal happens', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should not emit any event', (done) ->
			scanner = new DrivelistScanner(interval: 100)
			removeSpy = m.sinon.spy()
			scanner.on('remove', removeSpy)
			addSpy = m.sinon.spy()
			scanner.on('add', addSpy)
			setTimeout ->
				m.chai.expect(removeSpy).to.not.have.been.called
				m.chai.expect(addSpy).to.not.have.been.called
				scanner.stop()
				done()
			, 500

	describe 'given two additions that happen at the same time', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([ { foo: 'bar' }, { foo: 'baz' } ]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should emit exactly two addition events', (done) ->
			scanner = new DrivelistScanner(interval: 100)
			addSpy = m.sinon.spy()
			scanner.on('add', addSpy)
			removeSpy = m.sinon.spy()
			scanner.on('remove', removeSpy)
			setTimeout ->
				m.chai.expect(addSpy).to.have.been.calledTwice
				m.chai.expect(removeSpy).to.not.have.been.called
				m.chai.expect(addSpy).to.have.been.calledWith(foo: 'bar')
				m.chai.expect(addSpy).to.have.been.calledWith(foo: 'baz')
				scanner.stop()
				done()
			, 500

	describe 'given two removals that happen at the same time', ->

		beforeEach ->
			@getDrivesStub = m.sinon.stub(DrivelistScanner, 'getDrives')
			@getDrivesStub.returns(Promise.resolve([]))

		afterEach ->
			@getDrivesStub.restore()

		it 'should emit exactly two removal events', (done) ->
			scanner = new DrivelistScanner
				interval: 100
				drives: [
					{ foo: 'bar' }
					{ foo: 'baz' }
				]

			removeSpy = m.sinon.spy()
			scanner.on('remove', removeSpy)
			addSpy = m.sinon.spy()
			scanner.on('add', addSpy)
			setTimeout ->
				m.chai.expect(addSpy).to.not.have.been.called
				m.chai.expect(removeSpy).to.have.been.calledTwice
				m.chai.expect(removeSpy).to.have.been.calledWith(foo: 'bar')
				m.chai.expect(removeSpy).to.have.been.calledWith(foo: 'baz')
				scanner.stop()
				done()
			, 500

	describe 'given an instantiated drive scanner', ->

		beforeEach ->
			@scanner = new DrivelistScanner ->
				return Promise.resolve([])

		afterEach ->
			@scanner.stop()

		it 'should throw an error if stop() can not find the interval id', ->
			m.chai.expect =>
				@scanner.stop.call(null)
			.to.throw('Can\'t stop interval. Are you calling stop() with the right context?')

	describe 'given a drivelist object', ->

		beforeEach ->
			@drivelistListAsyncstub = m.sinon.stub(drivelist, 'listAsync')
			@drivelistListAsyncstub.returns Promise.resolve [
				{
					device: '\\\\.\\PHYSICALDRIVE0',
					description: 'WDC WD10JPVX-75JC3T0',
					size: '1000 GB'
					mountpoint: 'C:',
					system: true
				},
				{
					device: '\\\\.\\PHYSICALDRIVE1',
					description: 'Generic STORAGE DEVICE USB Device',
					size: '15 GB'
					mountpoint: 'D:',
					system: false
				}
			]

		afterEach ->
			@drivelistListAsyncstub.restore()

		it 'should eventually become an object[] of non-system drives', ->
			promise = DrivelistScanner.getDrives()
			m.chai.expect(promise).to.eventually.become [
				{
					device: '\\\\.\\PHYSICALDRIVE1',
					description: 'Generic STORAGE DEVICE USB Device',
					size: '15 GB'
					mountpoint: 'D:',
					system: false
				}
			]
