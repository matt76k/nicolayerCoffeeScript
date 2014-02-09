chai = require 'chai'
chai.should()

NicoLayer = require("../src/nicolayer")

describe 'Layer',->
  t = 1

  before ->
    t = 3
  

  it "should exist", ->
    t.should.exist
