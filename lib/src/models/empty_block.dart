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
      vector2: Vector2(json['x'], json['y']),
      coordinates: json['coordinates'] is Iterable
          ? List.from(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    print("empty here ???");
    return {
      if (vector2 != null) "x": vector2?.x,
      if (vector2 != null) "y": vector2?.y,
      if (coordinates != null) "coordinates": coordinates?.map((e) => e).toList(),
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return """
    {   
        "vector2": $vector2,
        "coordinates": $coordinates,
    }
    """;
  }
}
