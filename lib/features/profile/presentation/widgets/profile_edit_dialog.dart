import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ProfileEditDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onSave;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  const ProfileEditDialog({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _ProfileEditDialogState createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            errorMaxLines: 3,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
      actions: [
        if (!widget.readOnly)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        if (widget.readOnly)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        if (!widget.readOnly)
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                widget.onSave(_controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
      ],
    );
  }
}