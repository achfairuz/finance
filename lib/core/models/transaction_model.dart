import 'dart:convert';

import 'package:finance/core/models/rekening_model.dart';

class TransactionModel {
  final int id;
  final int rekening_id;
  final String date;
  final String time;
  final String title;
  final String category;
  final double amount;
  final String information;
  final String type;
  final RekeningModel? rekening;
  final String createdAt;
  final String updatedAt;

  TransactionModel({
    required this.id,
    required this.rekening_id,
    required this.date,
    required this.time,
    required this.title,
    required this.category,
    required this.amount,
    required this.information,
    required this.type,
    this.rekening,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      rekening_id: json['rekening_id'],
      date: json['date'],
      time: json['time'],
      title: json['title'],
      category: json['category'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      information: json['information'],
      type: json['type'],
      rekening: json['rekening'] != null
          ? RekeningModel.fromJson(json['rekening'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rekening_id': rekening_id,
      'date': date,
      'time': time,
      'title': title,
      'category': category,
      'amount': amount,
      'information': information,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
