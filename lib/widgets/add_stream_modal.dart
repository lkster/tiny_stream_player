import 'package:flutter/widgets.dart';
import 'package:tiny_stream_player/widgets/layout/modal.dart';

import 'layout/button.dart';
import 'layout/text_field.dart';

final class AddStreamModal extends StatefulWidget {
  final Function(String resource) onSubmit;

  const AddStreamModal({
    super.key,
    required this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => AddStreamModalState();
}

final class AddStreamModalState extends State<AddStreamModal> {
  final _urlTextFieldController = TextEditingController();
  final GlobalKey<TspModalState> _modalKey = GlobalKey();

  void openModal() {
    _modalKey.currentState!.openModal();
  }

  void closeModal() {
    _urlTextFieldController.text = '';
    _modalKey.currentState!.closeModal();
  }

  void _onSubmit() {
    if (_urlTextFieldController.text.trim().isEmpty) {
      return;
    }

    widget.onSubmit(_urlTextFieldController.text.trim());
    closeModal();
  }

  @override
  void dispose() {
    _urlTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TspModal(
      key: _modalKey,
      title: 'Add stream',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TspTextField(
            controller: _urlTextFieldController,
            hintText: 'URL to the stream',
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TspButton.secondary(
            onPressed: closeModal,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 5),
          TspButton.primary(
            onPressed: _onSubmit,
            child: const Text('Add Stream'),
          ),
        ],
      ),
    );
  }
}
