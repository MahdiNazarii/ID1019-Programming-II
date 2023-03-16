# Written by Mahdi Nazari
defmodule Snapshot do
  def snapshot() do
    camera = Camera.normal({1920, 1080})

    obj1 = %Sphere{radius: 20, pos: {-220, 0, 600}, color: {0.7, 0.7, 0.7}, brilliance: 0} # Mercury
    obj2 = %Sphere{radius: 30, pos: {-150, -50, 550}, color: {0.8, 0.8, 0}, brilliance: 0}  #Venus
    obj3 = %Sphere{radius: 40, pos: {-50, 0, 600}, color: {0, 0.4, 1}, brilliance: 0} # Earth
    obj4 = %Sphere{radius: 25, pos: {30, -50, 500}, color: {0.8, 0.5, 0}, brilliance: 0}  # Mars
    obj5 = %Sphere{radius: 70, pos: {130, -50, 400}, color: {0.7, 0.8, 0.9}, brilliance: 1} # Jupiter
    obj6 = %Sphere{radius: 25, pos: {250, 50, 700}, color: {0.7, 0.7, 0.4}, brilliance: 0} # Saturn
    obj7 = %Sphere{radius: 20, pos: {330, 120, 900}, color: {0.6, 1.0, 1.0}, brilliance: 0} # Uranus
    obj8 = %Sphere{radius: 20, pos: {360, 150, 900}, color: {0, 0, 0.5}, brilliance: 0} # Neptune
    obj9 = %Sphere{radius: 10, pos: {420, 220, 1000}, color: {1.0, 0.9, 0.3}, brilliance: 0} # Pluto

    # Sol
    light1 = %Light{pos: {-500, 1000, 500}, color: {1.0, 0, 0.1}} # red
    light2 = %Light{pos: {-500, 1000, 550}, color: {0.9, 1.0, 0.2}} # yellow
    light3 = %Light{pos: {-500, 1000, 600}, color: {0.3, 0.3, 1.0}} # blue

    world = %World{
      objects: [obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9],
      lights: [light1, light2, light3],
      background: {0.0, 0.0, 0.0},
      ambient: {0.1, 0.1, 0.1},
      depth: 3
    }

    image = TracerReflection.tracer(camera, world)
    PPM.write("snapshot.ppm", image)
  end
end
