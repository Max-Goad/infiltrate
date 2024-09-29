class_name VisibilityLight extends PointLight2D

var component: LightComponent

func update_position(target_position: Vector2) -> void:
	match component.relativity:
		LightComponent.Relativity.WORLD_RELATIVE:
			self.global_position = target_position
			print(self.global_position)
		LightComponent.Relativity.CAMERA_RELATIVE:
			self.global_position = target_position + component.global_position
