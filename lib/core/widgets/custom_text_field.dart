import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final IconData? prefixIcon;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText && _obscureText,
      readOnly: widget.readOnly,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppConstants.primarySaffron,
                size: 22,
              )
            : null,
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 22,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffix,
        counterText: '',
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppConstants.primarySaffron,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) onDateSelected(date);
      },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'DD/MM/YYYY',
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppConstants.primarySaffron,
              size: 20,
            ),
          ),
          controller: TextEditingController(
            text: selectedDate != null
                ? '${selectedDate!.day.toString().padLeft(2, '0')}/'
                    '${selectedDate!.month.toString().padLeft(2, '0')}/'
                    '${selectedDate!.year}'
                : '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerField({
    super.key,
    required this.label,
    this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppConstants.primarySaffron,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) onTimeSelected(time);
      },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'HH:MM',
            prefixIcon: const Icon(
              Icons.access_time,
              color: AppConstants.primarySaffron,
              size: 20,
            ),
          ),
          controller: TextEditingController(
            text: selectedTime != null
                ? selectedTime!.format(context)
                : '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a time';
            }
            return null;
          },
        ),
      ),
    );
  }
}
