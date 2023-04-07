extends SceneTree

# To run this script
# godot -s test.gd

const NUMBER_OF_TESTS = 500000
const NUMBER_OF_OBJECTS = 50000  # enough to test and to not run out of memory

var uuid_util = preload('uuid.gd')

func benchmark_raw():
  print('Benchmarking ...')

  var uuids := []
  var begin = Time.get_unix_time_from_system()

  for i in range(NUMBER_OF_TESTS):
    uuid_util.v4()
    
  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_obj():
  print('Benchmarking ...')

  var begin = Time.get_unix_time_from_system()

  for i in range(NUMBER_OF_TESTS):
    uuid_util.new().free()  # immediately freeing does not seem to add much overhead

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_obj_to_dict():
  print('Setting up benchmark ...')
  var uuids = []
  for i in range(NUMBER_OF_OBJECTS):
    uuids.append(uuid_util.new())

  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_dict()

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Cleaning up ...')
  for uuid in uuids:
    uuid.free()
  print('Benchmark done')
  
func benchmark_obj_to_str():
  print('Setting up benchmark ...')
  var uuids = []
  for i in range(NUMBER_OF_OBJECTS):
    uuids.append(uuid_util.new())

  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_string()

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Cleaning up ...')
  for uuid in uuids:
    uuid.free()
  print('Benchmark done')
  
func benchmark_comp_raw():
  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for i in range(NUMBER_OF_TESTS):
    uuid_util.v4() == uuid_util.v4()

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_comp_obj():
  print('Setting up benchmark ...')
  var uuids = []
  for i in range(NUMBER_OF_OBJECTS*2):
    uuids.append(uuid_util.new())
  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for i in range(NUMBER_OF_OBJECTS):
    var uuid1 = uuids[i*2]
    var uuid2 = uuids[i*2+1]
    
    uuid1.is_equal(uuid2)

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Cleaning up ...')
  for uuid in uuids:
    uuid.free()
  print('Benchmark done')

func detect_collision():
  print('Detecting collision ...')

  var number_of_collision = 0
  var generated_uuid = {}

  for i in range(NUMBER_OF_TESTS):
    var key = uuid_util.v4()

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')  
  
func detect_collision_with_rng():
  print('Detecting collision with rng ...')
  
  var rng = RandomNumberGenerator.new()

  var number_of_collision = 0
  var generated_uuid = {}

  for i in range(NUMBER_OF_TESTS):
    var key = uuid_util.v4_rng(rng)

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')  

func _init():
  detect_collision()
  detect_collision_with_rng()
  
  print("\n----------------      Raw      ----------------")
  benchmark_raw()
  
  print("\n---------------- Simple object ----------------")
  benchmark_obj()
  
  print("\n----------------  Obj to dict  ----------------")
  benchmark_obj_to_dict()
  
  print("\n---------------- Obj to string ----------------")
  benchmark_obj_to_str()
  
  print("\n----------------  Compare raw  ----------------")
  benchmark_comp_raw()
  
  print("\n----------------  Compare obj  ----------------")
  benchmark_comp_obj()
  
  quit()
