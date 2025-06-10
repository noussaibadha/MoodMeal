import 'package:flutter/material.dart';
import 'package:mood_meal/services/course_item_service.dart';

class CourseItemScreen extends StatefulWidget {
  final String category;

  const CourseItemScreen({super.key, required this.category});

  @override
  State<CourseItemScreen> createState() => _CourseItemScreenState();
}

class _CourseItemScreenState extends State<CourseItemScreen> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await CourseItemService.getItems(widget.category);
    setState(() {
      items = data;
      isLoading = false;
    });
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Ajouter un article"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Ex: Lait"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nom = controller.text.trim();
                  if (nom.isNotEmpty) {
                    await CourseItemService.addItem(widget.category, nom);
                    Navigator.pop(context);
                    _loadItems();
                  }
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteItem(String id) async {
    await CourseItemService.deleteItem(id);
    _loadItems();
  }

  Future<void> _toggleCheck(String id, bool checked) async {
    await CourseItemService.toggleCheck(id, checked);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item['checked'] ?? false,
                      onChanged: (val) {
                        _toggleCheck(item['id'], val!);
                      },
                    ),
                    title: Text(item['nom'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteItem(item['id']),
                    ),
                  );
                },
              ),
    );
  }
}
