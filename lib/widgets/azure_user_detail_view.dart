/*
import 'package:flutter/material.dart';

import '../data/model/azureUser.dart';

class AzureUserDetailView extends StatefulWidget {
  AzureUser azureUser;
  bool isEdit;
  final Function(
    AzureUser newAzureUser,
  ) onChange;

  AzureUserDetailView(this.azureUser, this.onChange,
      {this.isEdit = true, Key? key})
      : super(key: key);

  @override
  State<AzureUserDetailView> createState() => _AzureUserDetailViewState();
}

class _AzureUserDetailViewState extends State<AzureUserDetailView> {
  late AzureUser azureUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    azureUser = AzureUser(
      email: widget.azureUser.email,
      read: widget.azureUser.read,
      write: widget.azureUser.write,
      admin: widget.azureUser.admin,
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text(azureUser.email,
                style: Theme.of(context).textTheme.subtitle1),
          ),
          Text('Permissions', style: Theme.of(context).textTheme.subtitle1),
          const Divider(),
          CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Colors.black,
            title: Text('Read', style: Theme.of(context).textTheme.subtitle2),
            value: azureUser.read,
            onChanged: widget.isEdit
                ? (value) {
                    if (value != null) {
                      setState(() {
                        azureUser.read = !azureUser.read;
                      });
                      widget.onChange(
                        AzureUser(
                          email: azureUser.email,
                          read: value,
                          write: azureUser.write,
                          admin: azureUser.admin,
                        ),
                      );
                    }
                  }
                : null,
          ),
          const Divider(),
          CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Colors.black,
            title: Text('Write', style: Theme.of(context).textTheme.subtitle2),
            value: azureUser.write,
            onChanged: widget.isEdit
                ? (value) {
                  if (value != null) {
                    setState(() {
                      azureUser.write = !azureUser.write;
                    });
                    widget.onChange(
                        AzureUser(
                          email: azureUser.email,
                          read: azureUser.read,
                          write: value,
                          admin: azureUser.admin,
                        ),
                      );
                  }
                }
                : null,
          ),
          const Divider(),
          CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Colors.black,
            title: Text('Admin', style: Theme.of(context).textTheme.subtitle2),
            value: azureUser.admin,
            onChanged: widget.isEdit
                ? (value) {
                  if (value != null) {
                    setState(() {
                      azureUser.admin = !azureUser.admin;
                    });
                    widget.onChange(
                        AzureUser(
                          email: azureUser.email,
                          read: azureUser.read,
                          write: azureUser.write,
                          admin: value,
                        ),
                      );
                  }
                }
                : null,
          ),
        ],
      ),
    );
  }
}
*/