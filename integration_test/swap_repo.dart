import 'package:bb_mobile/_core/domain/entities/settings.dart';
import 'package:bb_mobile/_core/domain/entities/swap.dart';
import 'package:bb_mobile/_core/domain/repositories/swap_repository.dart';
import 'package:bb_mobile/_utils/constants.dart';
import 'package:bb_mobile/locator.dart';
import 'package:bb_mobile/settings/domain/usecases/set_environment_usecase.dart';
import 'package:boltz/boltz.dart' as boltz;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late SwapRepository repository;

  group('BoltzSwapRepositoryImpl Test', () {
    setUpAll(() async {
      await Future.wait([
        Hive.initFlutter(),
        boltz.LibBoltz.init(),
      ]);
      await AppLocator.setup();
      await locator<SetEnvironmentUseCase>().execute(Environment.testnet);
      repository = locator<SwapRepository>(
        instanceName:
            LocatorInstanceNameConstants.boltzSwapRepositoryInstanceName,
      );
    });

    test('should return swap limits for Bitcoin to Lightning swaps', () async {
      final result = await repository.getSwapLimits(
        type: SwapType.lightningToLiquid,
      );

      expect(result, isA<SwapLimits>());
      expect(result.min, isA<int>());
      expect(result.max, isA<int>());
      expect(result.min, greaterThan(0));
      expect(result.max, greaterThan(result.min));
    });

    test('should return swap limits for Lightning to Bitcoin swaps', () async {
      final result = await repository.getSwapLimits(
        type: SwapType.lightningToBitcoin,
      );

      expect(result, isA<SwapLimits>());
      expect(result.min, isA<int>());
      expect(result.max, isA<int>());
      expect(result.min, greaterThan(0));
      expect(result.max, greaterThan(result.min));
    });

    test('should return swap limits for all swap types', () async {
      for (final swapType in SwapType.values) {
        final result = await repository.getSwapLimits(type: swapType);
        expect(result, isA<SwapLimits>(),
            reason: 'Failed for swap type: $swapType');
        expect(result.min, isA<int>(),
            reason: 'Failed for swap type: $swapType');
        expect(result.max, isA<int>(),
            reason: 'Failed for swap type: $swapType');
        expect(result.min, greaterThan(0),
            reason: 'Failed for swap type: $swapType');
        expect(result.max, greaterThan(result.min),
            reason: 'Failed for swap type: $swapType');
      }
    });
  });
}
