import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class AddStreamModal extends StatefulWidget {
  final Function(String resource) onSubmit;
  final VoidCallback onCancel;

  const AddStreamModal({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<StatefulWidget> createState() => _AddStreamModalState();
}

final class _AddStreamModalState extends State<AddStreamModal> {
  final _urlTextFieldController = TextEditingController();

  void _onSubmit() {
    if (_urlTextFieldController.text.trim().isEmpty) {
      return;
    }

    widget.onSubmit(_urlTextFieldController.text.trim());
  }

  void _onCancel() {
    widget.onCancel();
  }

  @override
  void dispose() {
    _urlTextFieldController.dispose();
    super.dispose();
  }

  Widget _buildContainer({required Widget child}) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlTextFieldController,
            decoration: const InputDecoration(hintText: 'URL to the stream'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _onCancel,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 5),
              TextButton(
                onPressed: _onSubmit,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Add Stream'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
