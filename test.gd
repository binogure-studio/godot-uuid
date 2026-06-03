extends SceneTree

# To run this script
# godot -s test.gd

const NUMBER_TEST_FOR_COLLISION: int = 100000
const NUMBER_OF_TESTS: int = 50000
const NUMBER_OF_OBJECTS: int = 50000  # enough to test and to not run out of memory

const UUID = preload('addons/uuid/uuid.gd')

func benchmark_raw():
  print('Benchmarking ...')

  var begin: int = Time.get_unix_time_from_system()
  var index: int = 0

  while index < NUMBER_OF_TESTS:
    UUID.v4()
    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')

func benchmark_raw_rng():
  print('Benchmarking ...')

  var rng: RandomNumberGenerator = RandomNumberGenerator.new()
  var begin: int = Time.get_unix_time_from_system()
  var index: int = 0

  while index < NUMBER_OF_TESTS:
    UUID.v4_rng(rng)
    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')

func benchmark_obj():
  print('Benchmarking ...')

  var begin: int = Time.get_unix_time_from_system()
  var index: int = 0

  while index < NUMBER_OF_TESTS:
    UUID.new()
    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
   NUMBER_OF_TESTS / duration,
   (duration / NUMBER_OF_TESTS) * 1000000,
   duration
  ])
  print('Benchmark done')

func benchmark_obj_rng():
  print('Benchmarking ...')

  var rng: RandomNumberGenerator = RandomNumberGenerator.new()
  var begin: int = Time.get_unix_time_from_system()
  var index: int = 0

  while index < NUMBER_OF_TESTS:
    UUID.new(rng)
    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
    NUMBER_OF_TESTS / duration,
    (duration / NUMBER_OF_TESTS) * 1000000,
    duration
  ])
  print('Benchmark done')

func benchmark_obj_to_dict():
  print('Setting up benchmark ...')
  var uuids: Array[UUID] = []
  var index: int = 0

  while index < NUMBER_OF_OBJECTS:
    uuids.push_back(UUID.new())
    index += 1

  print('Benchmarking ...')
  var begin: int = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_dict()

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
    NUMBER_OF_OBJECTS / duration,
    (duration / NUMBER_OF_OBJECTS) * 1000000,
    duration
  ])
  print('Benchmark done')

func benchmark_obj_to_str():
  print('Setting up benchmark ...')
  var uuids: Array[UUID] = []
  var index: int = 0

  while index < NUMBER_OF_OBJECTS:
    uuids.push_back(UUID.new())
    index += 1

  print('Benchmarking ...')
  var begin: int = Time.get_unix_time_from_system()

  for uuid in uuids:
    uuid.as_string()

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
    NUMBER_OF_OBJECTS / duration,
    (duration / NUMBER_OF_OBJECTS) * 1000000,
    duration
  ])

  print('Benchmark done')

func benchmark_comp_raw():
  print('Setting up benchmark ...')
  var uuids: Array[String] = []
  var index: int = 0
  var collisions: int = 0

  print('Benchmarking ...')
  var begin: int = Time.get_unix_time_from_system()

  while index < NUMBER_OF_OBJECTS:
    var uuid: String = UUID.v4()

    if uuid in uuids:
      collisions += 1

    uuids.push_back(uuid)
    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print("%s collisions detected" % [collisions])
  print("%s total comparison operations" % [NUMBER_OF_OBJECTS])
  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
    NUMBER_OF_OBJECTS / duration,
    (duration / NUMBER_OF_OBJECTS) * 1000000,
    duration
  ])
  print('Benchmark done')

func benchmark_comp_obj():
  print('Setting up benchmark ...')
  var uuids: Array[UUID] = []
  var index: int = 0
  var collisions: int = 0

  print('Benchmarking ...')
  var begin: int = Time.get_unix_time_from_system()

  while index < NUMBER_OF_OBJECTS:
    var uuid: UUID = UUID.new()

    if uuids.find_custom(_find_uuid.bind(uuid)) > -1:
      collisions += 1

    uuids.push_back(uuid)

    index += 1

  var duration: float = 1.0 * Time.get_unix_time_from_system() - begin

  print("%s collisions detected" % [collisions])
  print("%s total comparison operations" % [NUMBER_OF_OBJECTS])
  print('uuid/sec: %.02f   avg time: %.4fus   total time: %.2fs' % [
    NUMBER_OF_OBJECTS / duration,
    (duration / NUMBER_OF_OBJECTS) * 1000000,
    duration
  ])

  print('Benchmark done')

func _find_uuid(object: UUID, expected: UUID) -> bool:
  return expected.is_equal(object)

func detect_collision():
  print('Detecting collision ...')

  var number_of_collision: int = 0
  var generated_uuid: Dictionary[String, bool] = {}
  var index: int = 0

  while index < NUMBER_TEST_FOR_COLLISION:
    var key: String = UUID.v4()

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true

    index += 1

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')

func detect_collision_with_rng():
  print('Detecting collision with rng ...')

  var rng: RandomNumberGenerator = RandomNumberGenerator.new()
  var number_of_collision: int = 0
  var generated_uuid: Dictionary[String, bool] = {}
  var index: int = 0

  while index < NUMBER_TEST_FOR_COLLISION:
    var key: String = UUID.v4_rng(rng)

    if generated_uuid.has(key):
      number_of_collision += 1

    else:
      generated_uuid[key] = true

    index += 1

  print('Number of collision: %s' % [ number_of_collision ])
  print('Collision detection done')

func test_is_equal():
  var uuid_1: UUID = UUID.new()
  var uuid_2: UUID = UUID.new()
  var uuid_3: UUID = UUID.new()

  uuid_3._uuid = uuid_1.as_array()

  print('Testing is_equal function')

  if uuid_2.is_equal(uuid_1):
    print('"is_equal" ain\'t working correctly (different uuid are identicals)')

  elif not uuid_3.is_equal(uuid_1):
    print('"is_equal" ain\'t working correctly (duplicated array not identical)')

  print('Done.')

func _init():
  test_is_equal()
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
