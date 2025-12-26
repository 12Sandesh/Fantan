components {
  id: "card"
  component: "/scripts/card.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"back\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/atlas/cards.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.3
    y: 0.3
    z: 0.3
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"card\"\n"
  "mask: \"dropzone\"\n"
  "mask: \"cursor\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      x: -17.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"card_collider\"\n"
  "  }\n"
  "  data: 11.5\n"
  "  data: 40.5\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
