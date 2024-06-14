import 'package:flame/components.dart';

class EmptyBlock {
  Vector2? vector2;

  //y first, x second
  List<int>? coordinates = [];

  EmptyBlock({
    this.vector2,
    this.coordinates,
  });

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
