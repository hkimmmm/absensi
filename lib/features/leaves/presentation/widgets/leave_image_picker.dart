import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/leave_controller.dart';

class LeaveImagePicker extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  @override
  // ignore: overridden_fields
  final Key? key;

  LeaveImagePicker({this.key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final controller = Provider.of<LeaveController>(context, listen: false);
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final base64String =
        'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';

    controller.fotoBuktiBase64.value = base64String;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LeaveController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.fotoBuktiBase64.value == null
            ? TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Upload Foto Bukti'),
                onPressed: () => _pickImage(context),
              )
            : Column(
                children: [
                  if (controller.fotoBuktiBase64.value != null)
                    Image.memory(
                      base64Decode(
                          controller.fotoBuktiBase64.value!.split(',')[1]),
                    ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus Foto Bukti'),
                    onPressed: () => controller.fotoBuktiBase64.value = null,
                  )
                ],
              ),
      ],
    );
  }
}
