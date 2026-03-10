import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final String? id;
  final String name;
  final int age;
  final String gender;
  final String recordingLocation;
  final String? audioFilePath;
  final String? audioFileName;
  final DateTime recordedAt;

  const PatientModel({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.recordingLocation,
    this.audioFilePath,
    this.audioFileName,
    required this.recordedAt,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? recordingLocation,
    String? audioFilePath,
    String? audioFileName,
    DateTime? recordedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      recordingLocation: recordingLocation ?? this.recordingLocation,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      audioFileName: audioFileName ?? this.audioFileName,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'recordingLocation': recordingLocation,
      'audioFilePath': audioFilePath,
      'audioFileName': audioFileName,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      recordingLocation: json['recordingLocation'] as String,
      audioFilePath: json['audioFilePath'] as String?,
      audioFileName: json['audioFileName'] as String?,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    gender,
    recordingLocation,
    audioFilePath,
    audioFileName,
    recordedAt,
  ];
}
