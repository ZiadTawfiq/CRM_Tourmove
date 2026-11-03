class CommentModel {
  final int id;
  final String comment;
  final DateTime createdAt;
  final String author;

  CommentModel({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      author: json['author'] ?? 'المستخدم',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'author': author,
    };
  }
}

class ProjectModel {
  final int id;
  final String name;
  final String location;
  final double startingPrice;

  ProjectModel({
    required this.id,
    required this.name,
    required this.location,
    required this.startingPrice,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? 'القاهرة الجديدة',
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'startingPrice': startingPrice,
    };
  }
}

class ChannelModel {
  final int id;
  final String name;

  ChannelModel({
    required this.id,
    required this.name,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int role;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] is int ? json['role'] : int.tryParse(json['role'].toString()) ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
