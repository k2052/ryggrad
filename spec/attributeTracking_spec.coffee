describe "Model Attribute Tracking", ->
  Puppy = undefined
  spy = undefined

  beforeEach ->
    class Puppy extends Ryggrad.Model
      @configure("Puppy", "name")
      @extend Ryggrad.AttributeTracking

    spy = sinon.spy()

  it 'fires an update:name event when name is updated', ->
    gus = Puppy.create(name: 'gus')
    gus.bind 'update:name', spy
    gus.updateAttribute('name', 'henry')
    spy.should.have.been.called

  it "doesn't fire an update:name event if the new name isn't different", ->
    gus = Puppy.create(name: 'gus')
    gus.bind 'update:name', spy
    gus.updateAttribute('name', 'gus')
    spy.called.should.be.false

  it "works with refreshed models", ->
    Puppy.refresh({name: 'gus', id: 1})
    gus = Puppy.find(1)
    gus.bind 'update:name', spy
    gus.updateAttribute('name', 'jake')
    spy.called.should.be.true

  it "doesn't fire an event when an attribute is updated with an equivalent object", ->
    Puppy.refresh({name: {first: 'Henry', last: 'Lloyd'}, id: 1})
    henry = Puppy.find(1)
    henry.bind 'update:name', spy
    henry.updateAttribute('name', {first: 'Henry', last: "Lloyd"})
    spy.called.should.be.false
