import 'package:flutter/material.dart';

enum AzureUserPermission {
  read,
  write,
  admin,
}

class AzureUserPermissionsView extends StatefulWidget {
  bool read;
  bool write;
  bool admin;
  bool isEdit;
  // final Function(
  //   AzureUserPermission permission,
  //   bool permissionValue,
  // )? onChange;
  final Function(
    bool newRead,
    bool newWrite,
    bool newAdmin,
  )? onChange;

  AzureUserPermissionsView(
      {this.onChange,
      this.read = true,
      this.write = false,
      this.admin = false,
      this.isEdit = true,
      Key? key})
      : super(key: key);

  @override
  State<AzureUserPermissionsView> createState() =>
      _AzureUserPermissionsViewState();
}

class _AzureUserPermissionsViewState extends State<AzureUserPermissionsView> {
  late bool _read;
  late bool _write;
  late bool _admin;
  late bool isEdit;

  set read(bool value) {
    setState(() {
      _read = value;
      if (!value) {
        _write = false;
        _admin = false;
      }
    });
    // widget.onChange?.call(
    //   AzureUserPermission.read,
    //   value,
    // );
    widget.onChange?.call(
      _read,
      _write,
      _admin,
    );
  }

  set write(bool value) {
    setState(() {
      _write = value;
      if (!_write) {
        _admin = false;
      } else {
        _read = true;
      }
    });
    // widget.onChange?.call(
    //   AzureUserPermission.write,
    //   value,
    // );
        widget.onChange?.call(
      _read,
      _write,
      _admin,
    );
  }

  set admin(bool value) {
    setState(() {
      _admin = value;
      if (_admin) {
        _write = true;
        _read = true;
      }
    });
    // widget.onChange?.call(
    //   AzureUserPermission.admin,
    //   value,
    // );
    widget.onChange?.call(
      _read,
      _write,
      _admin,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read = widget.read;
    _write = widget.write;
    _admin = widget.admin;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child:
              Text('Permissions', style: Theme.of(context).textTheme.subtitle1),
        ),
        const Divider(),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0.0),
          activeColor: Colors.white,
          checkColor: Colors.black,
          title: Text('Read', style: Theme.of(context).textTheme.subtitle2),
          value: _read,
          onChanged: widget.isEdit
              ? (value) {
                  if (value != null) {
                    read = value;
                  }
                }
              : null,
        ),
        const Divider(),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0.0),
          activeColor: Colors.white,
          checkColor: Colors.black,
          title: Text('Write', style: Theme.of(context).textTheme.subtitle2),
          value: _write,
          onChanged: widget.isEdit
              ? (value) {
                  if (value != null) {
                    write = value;
                  }
                }
              : null,
        ),
        const Divider(),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0.0),
          activeColor: Colors.white,
          checkColor: Colors.black,
          title: Text('Admin', style: Theme.of(context).textTheme.subtitle2),
          value: _admin,
          onChanged: widget.isEdit
              ? (value) {
                  if (value != null) {
                    admin = value;
                  }
                }
              : null,
        ),
      ],
    );
  }
}
