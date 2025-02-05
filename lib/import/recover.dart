import 'package:bb_mobile/_ui/components/button.dart';
import 'package:bb_mobile/_ui/components/text.dart';
import 'package:bb_mobile/_ui/components/text_input.dart';
import 'package:bb_mobile/import/bloc/import_cubit.dart';
import 'package:bb_mobile/import/bloc/words_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ImportEnterWordsScreen extends StatelessWidget {
  const ImportEnterWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(32),
            for (var i = 0; i < 6; i++)
              Row(
                children: [
                  for (var j = 0; j < 2; j++)
                    ImportWordTextField(
                      index: i == 0 ? j : i * 2 + j,
                    ),
                ],
              ),
            const Gap(32),
            const _ImportWordsPassphrase(),
            const Gap(80),
            const _ImportWordsRecoverButton(),
          ],
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }
}

class ImportWordTextField extends StatefulWidget {
  const ImportWordTextField({super.key, required this.index});

  final int index;

  @override
  State<ImportWordTextField> createState() => _ImportWordTextFieldState();
}

class _ImportWordTextFieldState extends State<ImportWordTextField> {
  OverlayEntry? entry;
  final layerLink = LayerLink();
  final focusNode = FocusNode();
  final controller = TextEditingController();
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus)
        showOverLay();
      else
        hideOverlay();
    });

    controller.addListener(() {
      if (suggestions.isNotEmpty && suggestions.contains(controller.text)) return;

      hideOverlay();
      setState(() {
        suggestions = context.read<WordsCubit>().state.findWords(controller.text);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOverLay();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  void showOverLay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 24,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(24, size.height - 8),
          child: buildOverlay(),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay() {
    if (suggestions.isEmpty) {
      hideOverlay();
      return Container();
    }

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          for (final word in suggestions)
            ListTile(
              title: BBText.body(word),
              onTap: () {
                context.read<ImportWalletCubit>().wordChanged(widget.index, word);
                hideOverlay();
                focusNode.unfocus();
              },
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = context
        .select((ImportWalletCubit cubit) => cubit.state.words.elementAtOrNull(widget.index) ?? '');

    if (controller.text != text) controller.text = text;

    return Expanded(
      child: CompositedTransformTarget(
        link: layerLink,
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          height: 66,
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: BBText.body(
                  '${widget.index + 1}',
                  textAlign: TextAlign.right,
                ),
              ),
              const Gap(8),
              Expanded(
                child: BBTextInput.small(
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: (value) {
                    context.read<ImportWalletCubit>().wordChanged(widget.index, value);
                    hideOverlay();
                  },
                  value: text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportWordsPassphrase extends StatefulWidget {
  const _ImportWordsPassphrase();

  @override
  State<_ImportWordsPassphrase> createState() => _ImportWordsPassphraseState();
}

class _ImportWordsPassphraseState extends State<_ImportWordsPassphrase> {
  @override
  Widget build(BuildContext context) {
    final text = context.select((ImportWalletCubit cubit) => cubit.state.password);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: BBTextInput.big(
        value: text,
        onChanged: (value) => context.read<ImportWalletCubit>().passwordChanged(value),
        hint: 'Enter passphrase if needed',
      ),
    );
  }
}

class _ImportWordsRecoverButton extends StatelessWidget {
  const _ImportWordsRecoverButton();

  @override
  Widget build(BuildContext context) {
    final recovering = context.select((ImportWalletCubit cubit) => cubit.state.importing);
    final err = context.select((ImportWalletCubit cubit) => cubit.state.errImporting);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            child: BBButton.bigRed(
              label: 'Recover',
              onPressed: () {
                context.read<ImportWalletCubit>().recoverWalletClicked();
              },
              disabled: recovering,
            ),
          ),
          if (err.isNotEmpty) ...[
            const Gap(8),
            BBText.error(
              err,
            ),
          ],
        ],
      ),
    );
  }
}
