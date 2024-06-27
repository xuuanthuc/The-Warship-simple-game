import 'package:flame/components.dart';

class EmptyBlock {
  Vector2? vector2;

  //y first, x second
  List<int>? coordinates = [];

  EmptyBlock({
    this.vector2,
    this.coordinates,
  });

  factory EmptyBlock.fromJson(Map<String, dynamic> json) {
    return EmptyBlock(
      coordinates: json['coordinates'] is Iterable
          ? List.from(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (coordinates != null) "coordinates": coordinates?.map((e) => e).toList(),
    };
  }

  @override
  String toString() {
    return """
    {   
        "vector2": $vector2,
        "coordinates": $coordinates,
    }
    """;
  }
}
