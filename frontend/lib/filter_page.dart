import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final String? selectedTag;

  const FilterPage({super.key, this.selectedTag});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> _tags = [
    "Reset",
    "vegetarian",
    "keto",
    "peanut-free",
    "egg-free",
    "pork-free",
    "gluten-free"
  ];
  String? _currentSelectedTag;

  @override
  void initState() {
    super.initState();
    _currentSelectedTag = widget.selectedTag; // 预选中当前筛选条件
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Recipes")),
      body: ListView(
        children: _tags.map((tag) {
          return RadioListTile<String?>(
            title: Text(tag),
            value: tag == "Reset" ? "" : tag,  // "Reset" 选项对应 null
            groupValue: _currentSelectedTag,
            onChanged: (value) {
              setState(() {
                _currentSelectedTag = value ?? ""; // 选中 "Reset" 则变为 null
              });
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _currentSelectedTag == "Reset" ? "" : _currentSelectedTag); // 返回选中的筛选条件
          },
          child: const Text("Apply Filter"),
        ),
      ),
    );
  }
}