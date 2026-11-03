import 'crm_enums.dart';
import 'crm_models.dart';

class LeadModel {
  final int id;
  String name;
  String phoneNumber;
  double? budget;
  int projectId;
  String? projectName;
  String? employeeId;
  String? employeeName;
  int? channelId;
  String? channelName;
  LeadStatus status;
  TypeLead typeLead;
  bool isDuplicated;
  int? cancellationReasonId;
  String? cancellationReason;
  DateTime created;
  DateTime updated;
  DateTime? assigned;
  DateTime? orientationDate;
  DateTime? reservationDate;
  DateTime? cancellationDate;
  List<CommentModel> comments;

  LeadModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.budget,
    required this.projectId,
    this.projectName,
    this.employeeId,
    this.employeeName,
    this.channelId,
    this.channelName,
    this.status = LeadStatus.freshLead,
    this.typeLead = TypeLead.sale,
    this.isDuplicated = false,
    this.cancellationReasonId,
    this.cancellationReason,
    required this.created,
    required this.updated,
    this.assigned,
    this.orientationDate,
    this.reservationDate,
    this.cancellationDate,
    this.comments = const [],
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    var rawComments = json['comments'] as List? ?? [];
    List<CommentModel> commentList = rawComments
        .map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return LeadModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      budget: (json['budget'] as num?)?.toDouble(),
      projectId: json['projectId'] is int ? json['projectId'] : int.tryParse(json['projectId'].toString()) ?? 1,
      projectName: json['projectName'],
      employeeId: json['employeeId']?.toString(),
      employeeName: json['employeeName'],
      channelId: json['channelId'] is int ? json['channelId'] : int.tryParse(json['channelId'].toString() ?? ''),
      channelName: json['channelName'],
      status: LeadStatus.fromId(json['status'] is int ? json['status'] : int.tryParse(json['status'].toString())),
      typeLead: TypeLead.fromId(json['typeLead'] is int ? json['typeLead'] : int.tryParse(json['typeLead'].toString())),
      isDuplicated: json['isDuplicated'] == true,
      cancellationReasonId: json['cancellationReasonId'] is int
          ? json['cancellationReasonId']
          : int.tryParse(json['cancellationReasonId']?.toString() ?? ''),
      cancellationReason: json['cancellationReason'],
      created: json['created'] != null ? DateTime.tryParse(json['created']) ?? DateTime.now() : DateTime.now(),
      updated: json['updated'] != null ? DateTime.tryParse(json['updated']) ?? DateTime.now() : DateTime.now(),
      assigned: json['assigned'] != null ? DateTime.tryParse(json['assigned']) : null,
      orientationDate: json['orientationDate'] != null ? DateTime.tryParse(json['orientationDate']) : null,
      reservationDate: json['reservationDate'] != null ? DateTime.tryParse(json['reservationDate']) : null,
      cancellationDate: json['cancellationDate'] != null ? DateTime.tryParse(json['cancellationDate']) : null,
      comments: commentList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'budget': budget,
      'projectId': projectId,
      'projectName': projectName,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'channelId': channelId,
      'channelName': channelName,
      'status': status.id,
      'typeLead': typeLead.id,
      'isDuplicated': isDuplicated,
      'cancellationReasonId': cancellationReasonId,
      'cancellationReason': cancellationReason,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'assigned': assigned?.toIso8601String(),
      'orientationDate': orientationDate?.toIso8601String(),
      'reservationDate': reservationDate?.toIso8601String(),
      'cancellationDate': cancellationDate?.toIso8601String(),
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }

  LeadModel copyWith({
    String? name,
    String? phoneNumber,
    double? budget,
    int? projectId,
    String? projectName,
    String? employeeId,
    String? employeeName,
    int? channelId,
    String? channelName,
    LeadStatus? status,
    TypeLead? typeLead,
    bool? isDuplicated,
    int? cancellationReasonId,
    String? cancellationReason,
    DateTime? assigned,
    DateTime? orientationDate,
    DateTime? reservationDate,
    DateTime? cancellationDate,
    List<CommentModel>? comments,
  }) {
    return LeadModel(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      budget: budget ?? this.budget,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      status: status ?? this.status,
      typeLead: typeLead ?? this.typeLead,
      isDuplicated: isDuplicated ?? this.isDuplicated,
      cancellationReasonId: cancellationReasonId ?? this.cancellationReasonId,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      created: created,
      updated: DateTime.now(),
      assigned: assigned ?? this.assigned,
      orientationDate: orientationDate ?? this.orientationDate,
      reservationDate: reservationDate ?? this.reservationDate,
      cancellationDate: cancellationDate ?? this.cancellationDate,
      comments: comments ?? this.comments,
    );
  }
}
