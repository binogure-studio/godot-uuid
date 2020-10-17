extends SceneTree

# To run this script
# godot -s test.gd

const NUMBER_OF_TEST = 500000

const uuid_util = preload('res://uuid.gd')

func benchmark():
  print('Benchmarking ...')

  var begin = OS.get_ticks_msec()
  var index = 0

  while index < NUMBER_OF_TEST:
    uuid_util.v4()
    index += 1

  var duration = 1.0 * OS.get_ticks_msec() - begin

  print('uuid/sec: %.02f (time: %sms)' % [ NUMBER_OF_TEST / duration, duration])
  print('Benchmark done')

func detect_collision():
  print('Detecting collision ...')

  var index = 0
  var number_of_collision = 0
  var generated_uuid = {}

  while index < NUMBER_OF_TEST:
    var key = uuid_util.v4()

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true

    index += 1

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')  

func _init():
  detect_collision()
  benchmark()
  quit()
