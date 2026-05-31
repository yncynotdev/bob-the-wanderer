# Bob the Wanderer

Our entry for [Game-Like Jam 09](https://itch.io/jam/gamelike-jam-009)

This project uses the [Godot](https://godotengine.org/) game engine.

## Project Structure

Use a **vertical-slice** layout whenever practical. Keep each feature self-contained so scenes, scripts, resources, and assets for the same gameplay unit live together.

### Example:

```
.
├── components
│   └── health
│       ├── scene
│       └── script
├── entities
│   ├── enemies
│   │   ├── bar
│   │   │   ├── assets
│   │   │   ├── scene
│   │   │   └── script
│   │   └── foo
│   │       ├── assets
│   │       ├── scene
│   │       └── script
│   └── player
│       ├── assets
│       ├── scene
│       └── script
├── icon.svg
├── icon.svg.import
├── level
│   ├── level_1
│   │   ├── res
│   │   ├── scene
│   │   └── script
│   ├── level_2
│   │   ├── res
│   │   ├── scene
│   │   └── script
│   ├── level_3
│   │   ├── res
│   │   ├── scene
│   │   └── script
│   └── level_4
│       ├── res
│       ├── scene
│       └── script
├── project.godot
└── REAME.md
```

## Naming Conventions

Follow the [Godot Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

| Type | Convention | Example |
| --- | --- | --- |
| File names | `snake_case` | `yaml_parser.gd` |
| Class names | `PascalCase` | `class_name YAMLParser` |
| Node names | `PascalCase` | `Camera3D`, `Player` |
| Functions | `snake_case` | `func load_level() -> void:` |
| Variables | `snake_case` | `var particle_effect: GPUParticles2D` |
| Signals | `snake_case` | `signal door_opened` |
| Constants | `CONSTANT_CASE` | `const MAX_SPEED: float = 30.0` |
| Enum names | `PascalCase` | `enum Element` |
| Enum values | `CONSTANT_CASE` | `{ EARTH, WATER, AIR, FIRE }` |

