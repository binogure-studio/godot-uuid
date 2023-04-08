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
  
  var test_number := 0
  while test_number < NUMBER_OF_TESTS:
    
    uuid_util.v4()
    
    test_number += 1
    
  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test_number / duration,
   (duration / test_number) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_raw_rng():
  print('Benchmarking ...')

  var rng = RandomNumberGenerator.new()
  var uuids := []
  var begin = Time.get_unix_time_from_system()

  var test_number = 0
  while test_number < NUMBER_OF_TESTS:
    
    uuid_util.v4_rng(rng)
    
    test_number += 1
  
  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test_number / duration,
   (duration / test_number) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_obj():
  print('Benchmarking ...')

  var begin = Time.get_unix_time_from_system()

  var test_number = 0
  while test_number < NUMBER_OF_TESTS:
  
    uuid_util.new().free()  # immediately freeing does not seem to add much overhead
    
    test_number += 1

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test_number / duration,
   (duration / test_number) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_obj_rng():
  print('Benchmarking ...')

  var rng = RandomNumberGenerator.new()
  var begin = Time.get_unix_time_from_system()

  var test_number = 0
  while test_number < NUMBER_OF_TESTS:
    
    uuid_util.new(rng).free()  # immediately freeing does not seem to add much overhead

    test_number += 1
  
  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test_number / duration,
   (duration / test_number) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_obj_to_dict():
  print('Setting up benchmark ...')
  var uuids = []
  var index = 0
  while index < NUMBER_OF_OBJECTS:
    uuids.append(uuid_util.new())
    index += 1

  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_dict()

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   uuids.size() / duration,
   (duration / uuids.size()) * 1000000,
   duration
  ])
  print('Cleaning up ...')
  for uuid in uuids:
    uuid.free()
  print('Benchmark done')
  
func benchmark_obj_to_str():
  print('Setting up benchmark ...')
  var uuids = []
  var index = 0
  while index < NUMBER_OF_OBJECTS:
    uuids.append(uuid_util.new())
    index += 1

  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_string()

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   uuids.size() / duration,
   (duration / uuids.size()) * 1000000,
   duration
  ])
  print('Cleaning up ...')
  for uuid in uuids:
    uuid.free()
  print('Benchmark done')
  
func benchmark_comp_raw():
  print('Setting up benchmark ...')
  var uuids = []
  var index = 0
  while index < NUMBER_OF_OBJECTS * 2:
    uuids.append(uuid_util.v4())
    index += 1
  
  var test = 0
  var max_tests = uuids.size() - 1
  var collisions = 0

  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  while test < max_tests:
    var uuid1 = uuids[test]
    var uuid2 = uuids[test + 1]
    
    if uuid1 == uuid2:
      collisions += 1
      print("Test #%s detected collision (%s = %s)" % [test, uuid1, uuid2])
      
    test += 1

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print("%s collisions detected" % collisions)
  print("%s total comparison operations" % test)
  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test / duration,
   (duration / test) * 1000000,
   duration
  ])
  print('Benchmark done')
  
func benchmark_comp_obj():
  print('Setting up benchmark ...')
  var uuids = []
  var index = 0
  while index < NUMBER_OF_OBJECTS * 2:
    uuids.append(uuid_util.new())
    index += 1
    
  var test = 0
  var max_tests = uuids.size() - 1
  var collisions = 0
    
  print('Benchmarking ...')
  var begin = Time.get_unix_time_from_system()

  while test < max_tests:
    var uuid1 = uuids[test]
    var uuid2 = uuids[test + 1]
    
    if uuid1.is_equal(uuid2):
      collisions += 1
      print("Test #%s detected collision (%s = %s)" % [test, uuid1, uuid2])
      
    test += 1

  var duration = 1.0 * Time.get_unix_time_from_system() - begin

  print("%s collisions detected" % collisions)
  print("%s total comparison operations" % test)
  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   test / duration,
   (duration / test) * 1000000,
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

  var index = 0
  while index < NUMBER_OF_TESTS:
    var key = uuid_util.v4()

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true
      
    index += 1

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')  
  
func detect_collision_with_rng():
  print('Detecting collision with rng ...')
  
  var rng = RandomNumberGenerator.new()

  var number_of_collision = 0
  var generated_uuid = {}

  var index = 0
  while index < NUMBER_OF_TESTS:
    var key = uuid_util.v4_rng(rng)

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true
      
    index += 1

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')  

func _init():
  detect_collision()
  detect_collision_with_rng()
  
  print("\n----------------      Raw      ----------------")
  benchmark_raw()
  
  print("\n---------------- Raw with rng  ----------------")
  benchmark_raw_rng()
  
  print("\n---------------- Simple object ----------------")
  benchmark_obj()
  
  print("\n---------------- Obj with rng  ----------------")
  benchmark_obj_rng()
  
  print("\n----------------  Obj to dict  ----------------")
  benchmark_obj_to_dict()
  
  print("\n---------------- Obj to string ----------------")
  benchmark_obj_to_str()
  
  print("\n----------------  Compare raw  ----------------")
  benchmark_comp_raw()
  
  print("\n----------------  Compare obj  ----------------")
  benchmark_comp_obj()
  
  quit()
