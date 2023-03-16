# Written by Johan Montelius and taken from https://github.com/ID1019/functional-programming/tree/master/exercises/tracer/src
defprotocol Object do

  def intersect(object, ray)

  def normal(object, ray, pos)

end
