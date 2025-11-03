import 'package:Lumixy/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class WhatsappInputField extends StatefulWidget {
  final String initialNumber;
  final Function(String) onChanged;

  const WhatsappInputField({
    Key? key,
    this.initialNumber = '',
    required this.onChanged,
  }) : super(key: key);

  @override
  _WhatsappInputFieldState createState() => _WhatsappInputFieldState();
}

class _WhatsappInputFieldState extends State<WhatsappInputField> {
  String _selectedPrefix = '970';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.initialNumber.isNotEmpty) {
      if (widget.initialNumber.startsWith('970')) {
        _selectedPrefix = '970';
        _controller.text = widget.initialNumber.substring(3);
      } else if (widget.initialNumber.startsWith('972')) {
        _selectedPrefix = '972';
        _controller.text = widget.initialNumber.substring(3);
      } else {
        _controller.text = widget.initialNumber;
      }
    }
  }

  void _updateValue() {
    final fullNumber = '$_selectedPrefix${_controller.text}';
    widget.onChanged(fullNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: '5********',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              onChanged: (value) => _updateValue(),
            ),
          ),

          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButton<String>(
              value: _selectedPrefix,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(value: '970', child: Text('+970')),
                DropdownMenuItem(value: '972', child: Text('+972')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPrefix = value!;
                  _updateValue();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}