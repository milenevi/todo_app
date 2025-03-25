/// Base abstract class for all entities
abstract class Entity {
  /// Unique identifier for the entity
  int get id;

  /// Convert entity to a map for serialization
  Map<String, dynamic> toJson();
}
