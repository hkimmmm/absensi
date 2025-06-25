import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/leave_controller.dart';

class LeaveForm extends StatefulWidget {
  const LeaveForm({super.key});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keteranganController = TextEditingController();
  final LeaveController controller = Get.find<LeaveController>();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync the text controller with the observable value
    if (_keteranganController.text != controller.keterangan.value) {
      _keteranganController.text = controller.keterangan.value;
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Jenis Cuti',
              labelStyle: TextStyle(color: Colors.blue),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            value:
                controller.jenis.value.isEmpty ? null : controller.jenis.value,
            items: ['cuti', 'sakit', 'izin', 'dinas']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => controller.jenis.value = value ?? '',
            validator: (val) =>
                val == null || val.isEmpty ? 'Pilih jenis cuti' : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Obx(() => Text(
                  controller.tanggalMulai.value == null
                      ? 'Pilih tanggal mulai'
                      : 'Tanggal mulai: ${DateFormat('dd MMM yyyy').format(controller.tanggalMulai.value!)}',
                  style: const TextStyle(color: Colors.blue),
                )),
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: controller.tanggalMulai.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) => Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(primary: Colors.blue),
                  ),
                  child: child!,
                ),
              );
              if (date != null && mounted) {
                controller.tanggalMulai.value = date;
              }
            },
          ),
          ListTile(
            title: Obx(() => Text(
                  controller.tanggalSelesai.value == null
                      ? 'Pilih tanggal selesai'
                      : 'Tanggal selesai: ${DateFormat('dd MMM yyyy').format(controller.tanggalSelesai.value!)}',
                  style: const TextStyle(color: Colors.blue),
                )),
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: controller.tanggalSelesai.value ??
                    (controller.tanggalMulai.value ?? DateTime.now()),
                firstDate: controller.tanggalMulai.value ?? DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) => Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(primary: Colors.blue),
                  ),
                  child: child!,
                ),
              );
              if (date != null && mounted) {
                controller.tanggalSelesai.value = date;
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _keteranganController,
            decoration: const InputDecoration(
              labelText: 'Keterangan',
              labelStyle: TextStyle(color: Colors.blue),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            maxLines: 3,
            onChanged: (value) => controller.keterangan.value = value,
            validator: (val) =>
                val == null || val.isEmpty ? 'Isi keterangan' : null,
          ),
          const SizedBox(height: 16),
          Obx(() => controller.fotoBuktiBase64.value == null
              ? TextButton.icon(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  label: const Text('Upload Foto Bukti',
                      style: TextStyle(color: Colors.blue)),
                  onPressed: () async {
                    await controller.pickImageFromGallery();
                    if (controller.error.value != null && mounted) {
                      Get.snackbar('Error', controller.error.value!,
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                )
              : Column(
                  children: [
                    Image.memory(
                      base64Decode(
                          controller.fotoBuktiBase64.value!.split(',')[1]),
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'Gagal memuat gambar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Hapus Foto Bukti',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => controller.fotoBuktiBase64.value = null,
                    ),
                  ],
                )),
          const SizedBox(height: 24),
          Obx(() => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue))
              : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final msg = await controller.submitLeave();
                      if (!mounted) return;

                      Get.snackbar(
                        msg == null ? 'Berhasil' : 'Error',
                        msg ?? 'Pengajuan cuti berhasil',
                        backgroundColor: msg == null ? Colors.blue : Colors.red,
                        colorText: Colors.white,
                      );

                      if (msg == null && mounted) {
                        _keteranganController.clear();
                        Get.back();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Ajukan Cuti'),
                )),
        ],
      ),
    );
  }
}
