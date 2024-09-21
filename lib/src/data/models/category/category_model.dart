import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/category/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.dateCreated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dateCreated': dateCreated,
      };

  factory CategoryModel.fromEntity(CategoryEntity categoryEntity) =>
      CategoryModel(
        id: categoryEntity.id,
        name: categoryEntity.name,
        dateCreated: categoryEntity.dateCreated,
      );

  factory CategoryModel.fromMap(
          QueryDocumentSnapshot<Map<String, dynamic>> map) =>
      CategoryModel(
        id: map['id'],
        name: map['name'],
        dateCreated: map['dateCreated'],
      );
}
