import 'crm_enums.dart';

class CommentModel {
  final int id;
  final String comment;
  final DateTime createdAt;
  final String author;
  final String? employeeId;

  CommentModel({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.author,
    this.employeeId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      comment: json['comment'] ?? json['text'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      author: json['author'] ?? json['employeeName'] ?? 'المستخدم',
      employeeId: json['employeeId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'author': author,
      'employeeId': employeeId,
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
  final int activeLeads;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.activeLeads = 0,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] is int ? json['role'] : int.tryParse(json['role'].toString()) ?? 2,
      activeLeads: json['activeLeads'] is int ? json['activeLeads'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'activeLeads': activeLeads,
    };
  }

  EmployeeRole get employeeRole => EmployeeRole.fromId(role);
}

class CancellationReasonModel {
  final int id;
  final String reason;

  CancellationReasonModel({required this.id, required this.reason});

  factory CancellationReasonModel.fromJson(Map<String, dynamic> json) {
    return CancellationReasonModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      reason: json['reason'] ?? '',
    );
  }
}

class LeadDuplicateRecord {
  final int id;
  final int leadId;
  final String leadName;
  final String phoneNumber;
  final int projectId;
  final String projectName;
  final String originalSalesRepId;
  final String originalSalesRepName;
  final String attemptedByEmployeeId;
  final String attemptedByEmployeeName;
  final DateTime createdAt;
  DuplicateStatus status;

  LeadDuplicateRecord({
    required this.id,
    required this.leadId,
    required this.leadName,
    required this.phoneNumber,
    required this.projectId,
    required this.projectName,
    required this.originalSalesRepId,
    required this.originalSalesRepName,
    required this.attemptedByEmployeeId,
    required this.attemptedByEmployeeName,
    required this.createdAt,
    this.status = DuplicateStatus.pending,
  });

  factory LeadDuplicateRecord.fromJson(Map<String, dynamic> json) {
    return LeadDuplicateRecord(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      leadId: json['leadId'] is int ? json['leadId'] : int.tryParse(json['leadId'].toString()) ?? 0,
      leadName: json['leadName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      projectId: json['projectId'] is int ? json['projectId'] : int.tryParse(json['projectId'].toString()) ?? 1,
      projectName: json['projectName'] ?? '',
      originalSalesRepId: json['originalSalesRepId']?.toString() ?? '',
      originalSalesRepName: json['originalSalesRepName'] ?? '',
      attemptedByEmployeeId: json['attemptedByEmployeeId']?.toString() ?? '',
      attemptedByEmployeeName: json['attemptedByEmployeeName'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: DuplicateStatus.fromId(json['status']),
    );
  }
}

class AuthResponseModel {
  final String token;
  final DateTime expiration;
  final EmployeeModel user;

  AuthResponseModel({
    required this.token,
    required this.expiration,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      expiration: json['expiration'] != null
          ? DateTime.tryParse(json['expiration'].toString()) ?? DateTime.now().add(const Duration(days: 7))
          : DateTime.now().add(const Duration(days: 7)),
      user: EmployeeModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
