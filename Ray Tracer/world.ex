# Written by Johan Montelius and taken from https://github.com/ID1019/functional-programming/tree/master/exercises/tracer/src
defmodule World do

  @background {0, 0, 0}
  @depth 2
  @ambient {0.3, 0.3, 0.3}
  @refraction 1

  defstruct(
    objects: [],
    lights: [],
    background: @background,
    depth: @depth,
    ambient: @ambient,
    refraction: @refraction
  )

end
