import 'dart:io';

import 'package:bb_mobile/_model/wallet.dart';
import 'package:bb_mobile/_pkg/file_storage.dart';
import 'package:bb_mobile/_pkg/storage/storage.dart';
import 'package:bb_mobile/_pkg/wallet/delete.dart';
import 'package:bb_mobile/_pkg/wallet/read.dart';
import 'package:bb_mobile/_pkg/wallet/update.dart';
import 'package:bb_mobile/wallet/bloc/event.dart';
import 'package:bb_mobile/wallet/bloc/wallet_bloc.dart';
import 'package:bb_mobile/wallet_settings/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSettingsCubit extends Cubit<WalletSettingsState> {
  WalletSettingsCubit({
    required Wallet wallet,
    required this.walletBloc,
    required this.walletUpdate,
    required this.storage,
    required this.walletRead,
    required this.walletDelete,
    required this.fileStorage,
    required this.secureStorage,
  }) : super(
          WalletSettingsState(
            wallet: wallet,
            mnemonic: [
              // ...mn1,
              // for (var i = 0; i < 12; i++) '',
            ],
          ),
        );

  final WalletBloc walletBloc;
  final WalletUpdate walletUpdate;
  final IStorage storage;
  final IStorage secureStorage;
  final WalletRead walletRead;
  final WalletDelete walletDelete;
  final FileStorage fileStorage;

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void saveNameClicked() async {
    emit(state.copyWith(savingName: true, errSavingName: ''));

    final wallet = state.wallet.copyWith(name: state.name);
    final err = await walletUpdate.updateWallet(
      wallet: wallet,
      storage: storage,
      walletRead: walletRead,
    );
    if (err != null) {
      emit(
        state.copyWith(
          errSavingName: err.toString(),
          savingName: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        savingName: false,
        wallet: wallet,
        savedName: true,
      ),
    );

    walletBloc.add(UpdateWallet(wallet));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(savedName: false));
  }

  Future loadSensitiveInfo() async {
    final (w, err) = await walletRead.getWalletDetails(
      saveDir: state.wallet.getStorageString(),
      storage: secureStorage,
    );
    if (err != null) return;

    final wallet = state.wallet.copyWith(
      mnemonic: w!.mnemonic,
      password: w.password,
      externalDescriptor: w.externalDescriptor,
      internalDescriptor: w.internalDescriptor,
      xpub: w.xpub,
    );

    emit(state.copyWith(wallet: wallet));
    // await Future.delayed(const Duration(milliseconds: 100));
  }

  void clearSensitiveInfo() {
    final wallet = state.wallet.copyWith(
      mnemonic: '',
      password: '',
      externalDescriptor: '',
      internalDescriptor: '',
      xpub: '',
    );

    emit(state.copyWith(wallet: wallet));
  }

  // void wordChanged(int index, String word) {
  //   final words = state.mnemonic.toList();
  //   words[index] = word;
  //   emit(
  //     state.copyWith(
  //       mnemonic: words,
  //       errTestingBackup: '',
  //     ),
  //   );
  // }

  void loadBackupClicked() async {
    final (w, err) = await walletRead.getWalletDetails(
      saveDir: state.wallet.getStorageString(),
      storage: secureStorage,
    );

    if (err != null) {
      emit(state.copyWith(errTestingBackup: err.toString()));
      return;
    }

    final words = w!.mnemonic.split(' ');
    final shuffled = words.toList()..shuffle();

    emit(
      state.copyWith(
        testMnemonicOrder: [],
        mnemonic: words,
        password: w.password ?? '',
        shuffledMnemonic: shuffled,
      ),
    );
  }

  void wordClicked(int shuffledIdx) {
    final testMnemonic = state.testMnemonicOrder.toList();
    if (testMnemonic.length == 12) return;

    final (word, isSelected, actualIdx) = state.shuffleElementAt(shuffledIdx);
    if (isSelected) return;
    if (actualIdx != testMnemonic.length) {
      invalidTestOrderClicked();
      return;
    }

    testMnemonic.add((word: word, shuffleIdx: shuffledIdx));

    emit(state.copyWith(testMnemonicOrder: testMnemonic));

    if (testMnemonic.length == 12) testingOrderCompleted();
  }

  void invalidTestOrderClicked() async {
    emit(
      state.copyWith(
        testMnemonicOrder: [],
        errTestingBackup: 'Invalid order',
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    final shuffled = state.mnemonic.toList()..shuffle();
    emit(
      state.copyWith(
        errTestingBackup: '',
        shuffledMnemonic: shuffled,
      ),
    );
  }

  void testingOrderCompleted() async {
    final words = state.testMneString();
    final mne = state.mnemonic.join(' ');
    if (words != mne) {
      return;
    }
    if (state.password != state.testBackupPassword) {
      return;
    }
    emit(state.copyWith(testingBackup: true, errTestingBackup: ''));

    final wallet = state.wallet.copyWith(backupTested: true);

    final updateErr = await walletUpdate.updateWallet(
      wallet: wallet,
      storage: storage,
      walletRead: walletRead,
    );
    if (updateErr != null) {
      emit(
        state.copyWith(
          errTestingBackup: updateErr.toString(),
          testingBackup: false,
        ),
      );
      return;
    }

    walletBloc.add(UpdateWallet(wallet));
    emit(
      state.copyWith(
        backupTested: true,
        testingBackup: false,
        wallet: wallet,
      ),
    );
  }

  void changePassword(String password) {
    emit(
      state.copyWith(
        testBackupPassword: password,
        errTestingBackup: '',
      ),
    );
  }

  void testBackupClicked() async {
    emit(state.copyWith(testingBackup: true, errTestingBackup: ''));
    final words = state.testMneString();
    final password = state.testBackupPassword;
    final (w, err) = await walletRead.getWalletDetails(
      saveDir: state.wallet.getStorageString(),
      storage: storage,
    );

    if (err != null) {
      emit(
        state.copyWith(
          errTestingBackup: err.toString(),
          testingBackup: false,
        ),
      );
      return;
    }

    final mne = w!.mnemonic == words;
    final psd = (w.password ?? '') == password;
    if (!mne) {
      {
        emit(
          state.copyWith(
            errTestingBackup: 'Mnemonic does not match',
            testingBackup: false,
          ),
        );
        return;
      }
    }
    if (!psd) {
      emit(
        state.copyWith(
          errTestingBackup: 'Password does not match',
          testingBackup: false,
        ),
      );
      return;
    }

    final wallet = state.wallet.copyWith(backupTested: true);

    final updateErr = await walletUpdate.updateWallet(
      wallet: wallet,
      storage: storage,
      walletRead: walletRead,
    );
    if (updateErr != null) {
      emit(
        state.copyWith(
          errTestingBackup: updateErr.toString(),
          testingBackup: false,
        ),
      );
      return;
    }

    walletBloc.add(UpdateWallet(wallet));
    emit(
      state.copyWith(
        backupTested: true,
        testingBackup: false,
        wallet: wallet,
      ),
    );
  }

  void clearnMnemonic() {
    emit(
      state.copyWith(
        mnemonic: [
          for (var i = 0; i < 12; i++) '',
        ],
        testBackupPassword: '',
      ),
    );
  }

  void backupToSD() async {
    emit(state.copyWith(savingFile: true, errSavingFile: ''));
    final (w, err) = await walletRead.getWalletDetails(
      saveDir: state.wallet.getStorageString(),
      storage: storage,
    );

    if (err != null) {
      emit(state.copyWith(savingFile: false, errSavingFile: err.toString()));
      return;
    }

    final wallet = w!;

    final fingerprint = wallet.cleanFingerprint();
    final folder = wallet.network == BBNetwork.Mainnet ? 'bitcoin' : 'testnet';

    final (appDocDir, errDir) = await fileStorage.getDownloadDirectory();

    if (errDir == null) {
      emit(
        state.copyWith(
          savingFile: false,
          errSavingFile: errDir.toString(),
        ),
      );
      return;
    }
    final file = File(appDocDir! + '/bullbitcoin_backup/$folder/$fingerprint.json');

    final (_, errSave) = await fileStorage.saveToFile(
      file,
      wallet.toJson().toString(),
    );
    if (errSave != null) {
      emit(
        state.copyWith(
          savingFile: false,
          errSavingFile: errSave.toString(),
        ),
      );
      return;
    }

    emit(state.copyWith(savingFile: false, savedFile: true));
    await Future.delayed(const Duration(seconds: 4));
    emit(state.copyWith(savedFile: false));
  }

  void deleteWalletClicked() async {
    emit(state.copyWith(deleting: true, errDeleting: ''));

    final err = await walletDelete.deleteWallet(
      saveDir: state.wallet.getStorageString(),
      storage: storage,
    );

    if (err != null) {
      emit(
        state.copyWith(
          deleting: false,
          errDeleting: err.toString(),
        ),
      );
      return;
    }

    final errr = await walletDelete.deleteWallet(
      saveDir: state.wallet.getStorageString(),
      storage: secureStorage,
    );

    if (errr != null) {
      emit(
        state.copyWith(
          deleting: false,
          errDeleting: errr.toString(),
        ),
      );
      return;
    }

    final (appDocDir, errDir) = await fileStorage.getAppDirectory();
    if (errDir != null) {
      emit(
        state.copyWith(
          deleting: false,
          errDeleting: errDir.toString(),
        ),
      );
      return;
    }
    final dbDir = appDocDir! + '/' + state.wallet.getStorageString();
    final errDeleting = await fileStorage.deleteFile(dbDir);
    if (errDeleting != null) {
      emit(
        state.copyWith(
          deleting: false,
          errDeleting: errDeleting.toString(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        deleting: false,
        deleted: true,
      ),
    );
  }
}

const mn1 = [
  'arrive',
  'term',
  'same',
  'weird',
  'genuine',
  'year',
  'trash',
  'autumn',
  'fancy',
  'need',
  'olive',
  'earn'
];

// arrive term same weird genuine year trash autumn fancy need olive earn
// arrive term same weird genuine year trash autumn fancy need olive earn
