import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId; // The unique ID given by Firebase
  final String ownerUserId; // To ensure only the creator sees the note
  final String title; // A title for the note, for better organization
  final String text; // The actual content

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
  });
}