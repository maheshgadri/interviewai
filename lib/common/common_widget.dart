// lib/common_button.dart
import 'package:flutter/material.dart';

class CommonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CommonWidget({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(200, 50), // Define minimum size
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class CustomDropdownFormField<T> extends FormField<T> {
  CustomDropdownFormField({
    Key? key,
    required List<T> items,
    T? value,
    required InputDecoration decoration,
    ValueChanged<T?>? onChanged,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
  }) : super(
    key: key,
    initialValue: value,
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState<T> field) {
      final InputDecoration effectiveDecoration =
      decoration.copyWith(errorText: field.errorText);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            decoration: effectiveDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: field.value,
                items: items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
                onChanged: field.didChange,
              ),
            ),
          ),
        ],
      );
    },
  );
}
