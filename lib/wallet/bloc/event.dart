import 'package:bb_mobile/_model/wallet.dart';

class WalletEvent {}

class LoadWallet extends WalletEvent {
  LoadWallet(this.saveDir);

  final String saveDir;
}

class SyncWallet extends WalletEvent {
  SyncWallet({this.cancelSync = false});

  final bool cancelSync;
}

class UpdateWallet extends WalletEvent {
  UpdateWallet(this.wallet);
  final Wallet wallet;
}

class GetBalance extends WalletEvent {}

class GetAddresses extends WalletEvent {}

class ListTransactions extends WalletEvent {}

class GetFirstAddress extends WalletEvent {}

class GetNewAddress extends WalletEvent {}
