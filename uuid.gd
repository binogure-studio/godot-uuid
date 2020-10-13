# Note: The code might not be as pretty it could be, since it's written
# in a way that maximizes performance. Methods are inlined and loops are avoided.
extends Node

static func uuidbin():
  # Randomize every time to minimize the risk of collisions
  randomize()
  # 16 random bytes with the bytes on index 6 and 8 modified
  return [
    randi() % 256, randi() % 256, randi() % 256, randi() % 256,
    randi() % 256, randi() % 256, ((randi() % 256) & 0x0f) | 0x40, randi() % 256,
    ((randi() % 256) & 0x3f) | 0x80, randi() % 256, randi() % 256, randi() % 256,
    randi() % 256, randi() % 256, randi() % 256, randi() % 256,
  ]

static func v4():
  # Randomize every time to minimize the risk of collisions
  randomize()
  # 16 random bytes with the bytes on index 6 and 8 modified
  var b = [
    randi() % 256, randi() % 256, randi() % 256, randi() % 256,
    randi() % 256, randi() % 256, ((randi() % 256) & 0x0f) | 0x40, randi() % 256,
    ((randi() % 256) & 0x3f) | 0x80, randi() % 256, randi() % 256, randi() % 256,
    randi() % 256, randi() % 256, randi() % 256, randi() % 256,
  ]

  return '%s-%s-%s-%s-%s' % [
    '%02x%02x%02x%02x' % [b[0], b[1], b[2], b[3]], # low
    '%02x%02x' % [b[4], b[5]], # mid
    '%02x%02x' % [b[6], b[7]], # hi
    '%02x%02x' % [b[8], b[9]], # clock
    '%02x%02x%02x%02x%02x%02x' % [b[10], b[11], b[12], b[13], b[14], b[15]], # node
  ]
