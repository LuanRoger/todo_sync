import 'package:freezed_annotation/freezed_annotation.dart';

part 'net_connection_state.freezed.dart';

@freezed
class NetConnectionState with _$NetConnectionState {
  const NetConnectionState._();

  const factory NetConnectionState({
    @Default(false) bool wifi,
    @Default(false) bool mobileData,
  }) = _NetConnectionState;

  bool get hasConnection => wifi || mobileData;
}
