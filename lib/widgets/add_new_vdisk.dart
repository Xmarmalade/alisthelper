import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/virtual_disk_state.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRcloneDisk extends ConsumerWidget {
  const AddNewRcloneDisk({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          final nameController = TextEditingController();
          final pathController = TextEditingController();
          final mountPointController = TextEditingController();
          final extraFlagsController = TextEditingController();
          final formKey = GlobalKey<FormState>();

          return SizedBox(
            height: 600,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(t.rcloneOperation.createVdisk,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18)),
                    Expanded(
                      child: AddRcloneDiskForm(
                        formKey: formKey,
                        nameController: nameController,
                        pathController: pathController,
                        mountPointController: mountPointController,
                        extraFlagsController: extraFlagsController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ref
                                  .read(rcloneProvider.notifier)
                                  .add(VirtualDiskState(
                                    isMounted: false,
                                    name: nameController.text,
                                    path: pathController.text,
                                    mountPoint: mountPointController.text,
                                    extraFlags: TextUtils.flagsParser(
                                      extraFlagsController.text,
                                    ),
                                  ));
                              // Save the form data
                              // Perform save operation here
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      label: Text('Add'),
      icon: const Icon(Icons.playlist_add),
    );
  }
}

class AddRcloneDiskForm extends StatelessWidget {
  const AddRcloneDiskForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.pathController,
    required this.mountPointController,
    required this.extraFlagsController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController pathController;
  final TextEditingController mountPointController;
  final TextEditingController extraFlagsController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Name',
                helperText: 'The name of the disk',
                hintText: 'OneDrive'),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Path',
                helperText: 'The path after https://localhost:port/dav/',
                hintText: 'onedrive'),
            controller: pathController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a path';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'MountPoint',
                helperText: 'The mount point of the disk',
                hintText: 'T'),
            controller: mountPointController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a mount point';
              } else if (value.length > 1) {
                return 'Please enter a single character';
              } else if (!value.contains(RegExp(r'[A-Za-z]'))) {
                return 'Please enter a letter';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'ExtraFlags',
                hintText: '--vfs-cache-mode writes --vfs-cache-max-size 100M',
                helperText: 'Extra flags to pass to rclone'),
            controller: extraFlagsController,
          ),
        ],
      ),
    );
  }
}
