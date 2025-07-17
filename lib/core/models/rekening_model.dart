import 'dart:convert';
import 'dart:ffi';

class RekeningModel {
  final int? id;
  final int? user_id;
  final String? name_bank;
  final double? balance;
  final String? tipe;
  final String? createdAt;
  final String? updatedAt;

  RekeningModel({
    this.id,
    this.user_id,
    this.name_bank,
    this.balance,
    this.tipe,
    this.createdAt,
    this.updatedAt,
  });

  factory RekeningModel.fromJson(Map<String, dynamic> json) {
    return RekeningModel(
      id: json['id'],
      user_id: json['user_id'],
      name_bank: json['name_bank'],
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      tipe: json['tipe'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name_bank': name_bank,
      'balance': balance,
      'tipe': tipe,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
