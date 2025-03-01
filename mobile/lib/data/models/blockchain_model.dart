import 'package:freezed_annotation/freezed_annotation.dart';

part 'blockchain_model.freezed.dart';
part 'blockchain_model.g.dart';

@freezed
abstract class BlockchainDataModel with _$BlockchainDataModel {
  const factory BlockchainDataModel({
    required String type,
    required String action,
    required int attendaceId,
    required int userId,
    required String date,
    String? clockIn,
    String? clockOut,
    required int timestamp,
  }) = _BlockchainDataModel;

  factory BlockchainDataModel.fromJson(Map<String, Object?> json) =>
      _$BlockchainDataModelFromJson(json);
}

@freezed
abstract class BlockchainModel with _$BlockchainModel {
  const factory BlockchainModel({
    required int id,
    required int blocIndex,
    required int timestamp,
    required BlockchainDataModel data,
    required String previousHash,
    required String hash,
    required int nonce,
  }) = _BlockchainModel;

  factory BlockchainModel.fromJson(Map<String, Object?> json) =>
      _$BlockchainModelFromJson(json);
}
