import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/token_storage.dart';
import '../../task/task_controller.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _startDate;
  DateTime? _deadline;

  String _scheduleType = 'daily';
  String _priority = 'medium';
  String _visibility = 'private';
  int _targetCycle = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, "Judul Task"),
              _buildTextField(_descController, "Deskripsi", maxLines: 3),

              const SizedBox(height: 12),

              _buildDropdown(
                label: "Tipe Jadwal",
                value: _scheduleType,
                items: const ['daily', 'weekly', 'once'],
                onChanged: (v) => setState(() => _scheduleType = v!),
              ),

              _buildDatePicker(
                label: "Tanggal Mulai",
                value: _startDate,
                onPick: (date) => setState(() => _startDate = date),
              ),

              _buildDatePicker(
                label: "Deadline",
                value: _deadline,
                onPick: (date) => setState(() => _deadline = date),
              ),

              _buildDropdown(
                label: "Priority",
                value: _priority,
                items: const ['low', 'medium', 'high'],
                onChanged: (v) => setState(() => _priority = v!),
              ),

              _buildDropdown(
                label: "Visibility",
                value: _visibility,
                items: const ['private', 'public'],
                onChanged: (v) => setState(() => _visibility = v!),
              ),

              const SizedBox(height: 12),

              _buildTargetCycle(),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submit,
                child: const Text("Simpan Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- WIDGET HELPERS ----------

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
        validator: (v) =>
            v == null || v.isEmpty ? "$label wajib diisi" : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required Function(DateTime) onPick,
  }) {
    return ListTile(
      title: Text(
        value == null
            ? label
            : "$label: ${DateFormat('dd MMM yyyy').format(value)}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDate: value ?? DateTime.now(),
        );
        if (date != null) onPick(date);
      },
    );
  }

  Widget _buildTargetCycle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Target Cycle"),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _targetCycle > 1
                  ? () => setState(() => _targetCycle--)
                  : null,
            ),
            Text(_targetCycle.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _targetCycle++),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- SUBMIT ----------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await TokenStorage.getToken();
    if (token == null) return;

    await context.read<TaskController>().addTask(
          token: token,
          data: {
            "judul_task": _titleController.text,
            "deskripsi": _descController.text,
            "schedule_type": _scheduleType,
            "start_date": _startDate?.toIso8601String(),
            "deadline": _deadline?.toIso8601String(),
            "target_cycle": _targetCycle,
            "priority": _priority,
            "visibility": _visibility,
          },
        );

    if (!mounted) return;
    Navigator.pop(context);
  }
}
