import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/sample_data.dart';
import '../services/app_services.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Шинэ уулзалт');
  final _descriptionController = TextEditingController(text: 'Сонирхол нэгтэй хүмүүсийн casual уулзалт.');
  final _locationController = TextEditingController(text: 'Сүхбаатар дүүрэг');
  final _capacityController = TextEditingController(text: '20');
  final _priceController = TextEditingController(text: '0');
  final _ageLimitController = TextEditingController(text: '13');
  String _category = 'Тоглоом';
  bool _corporate = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _ageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final user = services.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Эвент үүсгэх')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Шинэ эвент', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text('Үүсгэсэн эвент эхлээд pending төлөвтэй орж, админ panel дээр баталгаажуулах mock flow-той.'),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Гарчиг', prefixIcon: Icon(Icons.title_rounded)),
                          validator: (value) => value == null || value.trim().length < 3 ? 'Гарчиг хамгийн багадаа 3 тэмдэгт.' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          maxLength: 420,
                          decoration: const InputDecoration(labelText: 'Тайлбар', prefixIcon: Icon(Icons.description_outlined)),
                          validator: (value) => value == null || value.trim().length < 10 ? 'Тайлбар бага байна.' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _category,
                          items: SampleData.categories.where((item) => item != 'Бүгд').map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                          onChanged: (value) => setState(() => _category = value ?? _category),
                          decoration: const InputDecoration(labelText: 'Ангилал', prefixIcon: Icon(Icons.category_outlined)),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(labelText: 'Байршил', prefixIcon: Icon(Icons.place_outlined)),
                          validator: (value) => value == null || value.trim().isEmpty ? 'Байршил оруулна уу.' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _capacityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(labelText: 'Оролцогчийн тоо'),
                                validator: (value) => (int.tryParse(value ?? '') ?? 0) > 0 ? null : '1+ байх ёстой.',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(labelText: 'Үнэ ₮'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ageLimitController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(labelText: 'Насны шаардлага', prefixIcon: Icon(Icons.cake_outlined)),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _corporate,
                          onChanged: (value) => setState(() => _corporate = value),
                          title: const Text('Байгууллагын / corpo эвент'),
                          subtitle: const Text('Идэвхжүүлбэл байгууллагын эвент хэлбэрээр feed дээр харагдана.'),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Эвент нэмэх'),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            services.events.createEvent(
                              actor: user,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              category: _category,
                              locationName: _locationController.text,
                              capacity: int.tryParse(_capacityController.text) ?? 1,
                              priceMnt: int.tryParse(_priceController.text) ?? 0,
                              ageLimit: int.tryParse(_ageLimitController.text) ?? 13,
                              corporate: _corporate,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Эвент pending төлөвтэй нэмэгдлээ.')));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
