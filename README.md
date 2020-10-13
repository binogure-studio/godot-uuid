uuid - static uuid generator for Godot Engine
===========================================

The *uuid* class is a GDScript 'static' class that provides a unique identifier generation for [Godot Engine](https://godotengine.org).

Usage
-----

Copy the `uuid.gd` file in your project folder, and preload it using a constant.

```gdscript
const uuid_util = preload('res://uuid.gd')

func _init():
  print(uuid_util.v4())
```

Licensing
---------

MIT (See license file for more informations)
