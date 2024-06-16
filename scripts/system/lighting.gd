extends Node2D


func _ready () -> void:
    randomize()

    var starting_scales :Dictionary = {}
    for child in get_children():
        starting_scales[child] = child.scale.x

    while true:
        for child in get_children():
            var new_scale :float = randf_range(starting_scales[child] -0.3, starting_scales[child] +0.3)
            self.create_tween().tween_property(child, "scale", Vector2(new_scale, new_scale), 0.15)
        await get_tree().create_timer(0.15).timeout
