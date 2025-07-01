import 'dart:io';
import 'package:bus_theme/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DriverReportPage extends StatefulWidget {
  const DriverReportPage({super.key});

  @override
  State<DriverReportPage> createState() => _DriverReportPageState();
}

class _DriverReportPageState extends State<DriverReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  String _priority = 'Urgent';
  final Color primaryColor = const Color(0xFFFECF4C);

  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  final List<Map<String, dynamic>> _history = [
    {
      'desc': 'Flat tyre reported',
      'prio': 'Urgent',
      'status': 'Resolved',
      'date': '2025-06-25',
      'images': <File>[],
    },
    {
      'desc': 'Schedule delay submitted',
      'prio': 'Medium',
      'status': 'In Progress',
      'date': '2025-06-26',
      'images': <File>[],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  Future<void> _pickImages(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _images.addAll(pickedFiles.map((x) => File(x.path)));
        });
      }
    } else {
      final picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          _images.add(File(picked.path));
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_images.isNotEmpty) {
      final req = http.MultipartRequest('POST', Uri.parse(Api.uploadPhotoUrl));
      req.fields['description'] = _descCtrl.text;
      req.fields['priority'] = _priority;
      for (var img in _images) {
        req.files.add(await http.MultipartFile.fromPath('file', img.path));
      }
      await req.send();
    }

    setState(() {
      _history.insert(0, {
        'desc': _descCtrl.text.isEmpty ? 'No description' : _descCtrl.text,
        'prio': _priority,
        'status': 'Pending',
        'date': DateTime.now().toString().substring(0, 10),
        'images': List<File>.from(_images),
      });
      _descCtrl.clear();
      _priority = 'Urgent';
      _images.clear();
      _tab.index = 1;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Issue submitted to admin')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Reports'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'New Report'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          Column(
            children: [
              Expanded(child: _buildForm(context)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                    shadowColor: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          _buildHistory(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description Field (Optional)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryColor),
              ),
              child: TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Describe the issue... (Optional)',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Priority Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration.collapsed(hintText: ''),
                items: ['Urgent', 'Medium', 'Low']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
            ),
            const SizedBox(height: 16),

            // Image Picker Container with buttons at bottom
            Container(
              height: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _images.isEmpty ? Colors.grey : primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attach Images (Optional):'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _images.isNotEmpty
                        ? PageView.builder(
                            itemCount: _images.length,
                            itemBuilder: (_, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _images[index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No images selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImages(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImages(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: _history.length,
      itemBuilder: (_, i) {
        final item = _history[i];
        Color prioColor;
        switch (item['prio']) {
          case 'Urgent':
            prioColor = Colors.red;
            break;
          case 'Medium':
            prioColor = Colors.orange;
            break;
          default:
            prioColor = Colors.green;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.report_problem, color: prioColor),
                title: Text(
                  item['desc']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item['date']}  •  ${item['status']}'),
                trailing: Text(
                  item['prio']!,
                  style: TextStyle(
                    color: prioColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (item['images'] != null && (item['images'] as List).isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (item['images'] as List).length,
                    itemBuilder: (_, idx) {
                      final img = item['images'][idx];
                      if (img is File) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              img,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
