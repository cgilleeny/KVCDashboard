import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/UI/shared/app_colors.dart';

enum BasicDialogType {
  error('Error', Icons.error, errorColor),
  warning('Warning', Icons.warning, warningColor),
  success('Success', Icons.check, successColor),
  edit('Edit', Icons.edit, warningColor),
  add('Add', Icons.add, infoColor),
  info('Info', Icons.info, infoColor),
  portrait('Portrait', Icons.portrait, Colors.grey);

  const BasicDialogType(this.title, this.icon, this.color);

  final String title;
  final IconData icon;
  final Color color;
}
