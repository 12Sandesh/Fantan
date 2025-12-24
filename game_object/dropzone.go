components {
  id: "dropzone"
  component: "/scripts/dropzone.script"
}
embedded_components {
  id: "dropzone_sprite"
  type: "sprite"
  data: "default_animation: \"dropzone\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/atlas/background.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 1.4
    y: 2.0
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"dropzone\"\n"
  "mask: \"card\"\n"
  "mask: \"cursor\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"dropzone_collider\"\n"
  "  }\n"
  "  data: 25.0\n"
  "  data: 25.0\n"
  "  data: 24.5\n"
  "}\n"
  ""
}
