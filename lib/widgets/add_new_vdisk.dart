import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/virtual_disk_state.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/rclone_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// a lite provider bool to switch : autoMount and a setter
final autoMountProvider = StateProvider<bool>((ref) => false);

class AddNewRcloneDisk extends ConsumerWidget {
  const AddNewRcloneDisk({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isAlistRunning = ref.watch(alistProvider).isRunning;
    final bool isRcloneRunning = ref.watch(rcloneProvider).isRunning;

    return ElevatedButton.icon(
      onPressed: !(isAlistRunning && isRcloneRunning)
          ? null
          : () => showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  final nameController = TextEditingController();
                  final pathController = TextEditingController();
                  final mountPointController = TextEditingController();
                  final extraFlagsController = TextEditingController();
                  //final bool enableAutoMount = ref.watch(autoMountProvider);
                  final formKey = GlobalKey<FormState>();

                  return Dialog.fullscreen(
                    child: Scaffold(
                      floatingActionButton: FloatingActionButton(
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
                                    autoMount: ref.watch(autoMountProvider),
                                  ));
                              // Save the form data
                              // Perform save operation here
                              Navigator.pop(context);
                            }
                          },
                          tooltip: t.button.save,
                          child: const Icon(Icons.save)),
                      appBar: AppBar(
                        title: Text('Add new Virtual Disk'),
                      ),
                      body: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Column(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(t.rcloneOperation.createVdisk),
                              Expanded(
                                child: AddRcloneDiskForm(
                                  formKey: formKey,
                                  nameController: nameController,
                                  pathController: pathController,
                                  mountPointController: mountPointController,
                                  extraFlagsController: extraFlagsController,
                                  vd: VirtualDiskState(vendor: 'new'),
                                ),
                              ),
                            ],
                          ),
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

class AddRcloneDiskForm extends ConsumerWidget {
  const AddRcloneDiskForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.pathController,
    required this.mountPointController,
    required this.extraFlagsController,
    required this.vd,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController pathController;
  final TextEditingController mountPointController;
  final TextEditingController extraFlagsController;
  final VirtualDiskState vd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drives = ref.watch(rcloneProvider).alistRoot;

    final List<DropdownMenuEntry<String>> driveEntries =
        <DropdownMenuEntry<String>>[];

    for (final drive in drives) {
      driveEntries.add(DropdownMenuEntry<String>(value: drive, label: drive));
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        children: [
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                helperText: 'The name of the disk',
                prefixIcon: Icon(Icons.file_copy_rounded),
                hintText: 'OneDrive'),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            enabled: (vd.vendor == 'new'), // Disable if isedit is true
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.all(0),
            initialSelection: vd.path,
            controller: pathController,
            leadingIcon: const Icon(Icons.folder),
            label: const Text('Path'),
            hintText: 'onedrive',
            helperText: 'The path after https://localhost:port/dav/',
            dropdownMenuEntries: driveEntries,
            enabled: (vd.vendor == 'new'), // Disable if isedit is true
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MountPoint',
                prefixIcon: Icon(Icons.sd_storage_rounded),
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
          Padding(padding: EdgeInsets.only(top: 20)),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ExtraFlags',
                prefixIcon: Icon(Icons.code),
                hintText: '--vfs-cache-mode writes --vfs-cache-max-size 100M',
                helperText: 'Extra flags to pass to rclone'),
            controller: extraFlagsController,
          ),
          ListTile(
            contentPadding: EdgeInsets.all(8),
            title: const Text('Enable AutoMount'),
            subtitle:
                const Text('Automatically mount the disk on rclone startup.'),
            leading: const Icon(Icons.drive_file_move),
            trailing: Switch(
              value: ref.watch(autoMountProvider),
              onChanged: (bool value) {
                ref.read(autoMountProvider.notifier).state = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditRcloneDisk extends ConsumerWidget {
  const EditRcloneDisk({super.key, required this.disk});

  final VirtualDiskState disk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: disk.name);
    final pathController = TextEditingController(text: disk.path);
    final mountPointController = TextEditingController(text: disk.mountPoint);
    final extraFlagsController =
        TextEditingController(text: disk.extraFlags.join(' '));
    final formKey = GlobalKey<FormState>();

    return IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          ref.watch(autoMountProvider.notifier).state = disk.autoMount;
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return Dialog.fullscreen(
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(rcloneProvider.notifier)
                                .modify(VirtualDiskState(
                                  isMounted: false,
                                  name: nameController.text,
                                  path: pathController.text,
                                  mountPoint: mountPointController.text,
                                  extraFlags: TextUtils.flagsParser(
                                    extraFlagsController.text,
                                  ),
                                  autoMount: ref.watch(autoMountProvider),
                                ));
                            // Save the form data
                            // Perform save operation here
                            Navigator.pop(context);
                          }
                        },
                        tooltip: 'Save',
                        child: const Icon(Icons.save)),
                    appBar: AppBar(
                      title: Text('Add new Virtual Disk'),
                    ),
                    body: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(t.rcloneOperation.createVdisk),
                            Expanded(
                              child: AddRcloneDiskForm(
                                formKey: formKey,
                                nameController: nameController,
                                pathController: pathController,
                                mountPointController: mountPointController,
                                extraFlagsController: extraFlagsController,
                                vd: disk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
