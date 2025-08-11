import 'package:flutter/material.dart';

class ServiceProvider {
  final String name;
  final String service;
  final String city;
  final String phone;
  final String? email;
  final String? description;

  ServiceProvider({
    required this.name,
    required this.service,
    required this.city,
    required this.phone,
    this.email,
    this.description,
  });

  String getServiceLabel() {
    switch (service) {
      case 'photographer':
        return 'مصور';
      case 'video-editor':
        return 'مونتاج فيديوهات';
      case 'photo-editor':
        return 'تعديل صور';
      case 'printer':
        return 'طباعة صور';
      default:
        return service;
    }
  }

  IconData getServiceIcon() {
    switch (service) {
      case 'photographer':
        return Icons.camera_alt;
      case 'video-editor':
        return Icons.video_camera_back;
      case 'photo-editor':
        return Icons.edit;
      case 'printer':
        return Icons.print;
      default:
        return Icons.work;
    }
  }
}
