import 'dart:convert';

import 'package:intl/intl.dart';

class NotesImpNames{
  static final String tablename="Notes1";

  static final String id="id";
  static final String pin="pin";
  static final String title="title";
  static final String uniqueID="uniqueID";
  static final String content="content";
  static final String createdTime="createdTime";
  static final String isArchived = "isArchived"; // N
  static final List<String> values=[id,pin,title,content,createdTime,isArchived];

}


class Note{
  final int? id;
  final bool pin;
  final String title;
  final String uniqueID;

  final String content;
  final DateTime createdTime;
  final bool isArchived; // New field
  const Note({this.id,required this.title,required this.content,required this.pin,required this.createdTime,required this.uniqueID,this.isArchived=false});

  static Note fromJson(Map<String, Object?> json) {
    final dateFormat = DateFormat("dd MMM yyyy", "en_US");
    String dateString = (json[NotesImpNames.createdTime] as String).trim();

    // Log the raw string for debugging
    try {
      return Note(
        id: json[NotesImpNames.id] as int,
        title: json[NotesImpNames.title] as String,
        uniqueID: json[NotesImpNames.uniqueID] as String,
        content: json[NotesImpNames.content] as String,
        pin: json[NotesImpNames.pin] == 1,
        createdTime: dateFormat.parse(dateString),
        isArchived: json[NotesImpNames.isArchived] == 1, // Parse new column
      );
    } catch (e) {
      print("Error parsing date with DateFormat: $dateString - $e");
      // Fallback: Manual parsing for "dd MMM yyyy" format
      final parts = dateString.split(" ");
      if (parts.length == 3) {
        try {
          final day = int.parse(parts[0]);
          final monthStr = parts[1].toLowerCase();
          final year = int.parse(parts[2]);
          const months = {
            "jan": 1, "feb": 2, "mar": 3, "apr": 4, "may": 5, "jun": 6,
            "jul": 7, "aug": 8, "sep": 9, "oct": 10, "nov": 11, "dec": 12,
          };
          final month = months[monthStr];
          if (month != null) {
            return Note(
              id: json[NotesImpNames.id] as int,
              title: json[NotesImpNames.title] as String,
              uniqueID: json[NotesImpNames.uniqueID] as String,
              content: json[NotesImpNames.content] as String,
              pin: json[NotesImpNames.pin] == 1,
              createdTime: DateTime(year, month, day),
              isArchived: json[NotesImpNames.isArchived] == 1,
            );
          }
        } catch (e) {
          print("Fallback parsing failed: $dateString - $e");
        }
      }
      // Last resort: Use current date
      print("Using DateTime.now() as fallback for: $dateString");
      return Note(
        id: json[NotesImpNames.id] as int,
        title: json[NotesImpNames.title] as String,
        uniqueID: json[NotesImpNames.uniqueID] as String,

        content: json[NotesImpNames.content] as String,
        pin: json[NotesImpNames.pin] == 1,
        createdTime: DateTime.now(),
        isArchived: json[NotesImpNames.isArchived] == 1, // Parse new column
      );
    }
  }
 Note copy({
   int? id,
    bool? pin,
    bool? isArchived,
    String? title,
    String? content,
   String? uniqueID,
   DateTime? createdTime,}) {
    return Note(title: title ?? this.title,uniqueID: uniqueID ?? this.uniqueID, content: content??this.content, pin: pin??this.pin, createdTime: createdTime??this.createdTime,isArchived: isArchived ?? this.isArchived,);

}

  Map<String,Object?> tojason() {
    final dateFormat = DateFormat("dd MMM yyyy"); // Define the custom date format
    return {
      NotesImpNames.id: id,
      NotesImpNames.title: title,
      NotesImpNames.uniqueID: uniqueID,
      NotesImpNames.pin: pin ? 1 : 0,
      NotesImpNames.content: content,
      NotesImpNames.createdTime: dateFormat.format(createdTime), // Convert DateTime to string
      NotesImpNames.isArchived: isArchived ? 1 : 0, // Store as 1 or 0
    };
  }
}

//id INTEGER PRIMARY KEY AUTOINCREMENT,
//pin BOOLEAN NOT NULL,
  //  title TEXT NOT NULL,
//content TEXT NOT NULL,
  //  createdTime TEXT NOT NULL