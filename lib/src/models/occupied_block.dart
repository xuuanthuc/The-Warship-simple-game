class OccupiedBlock {
  String sprite;
  final int size;
  final int id;

  OccupiedBlock({
    required this.sprite,
    required this.size,
    required this.id,
  });

  factory OccupiedBlock.fromJson(Map<String, dynamic> json) {
    return OccupiedBlock(
      sprite: json['sprite'],
      size: json['size'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sprite": sprite,
      "size": size,
      "id": id,
    };
  }
}
