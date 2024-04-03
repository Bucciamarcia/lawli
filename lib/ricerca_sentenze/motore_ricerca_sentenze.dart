import 'package:flutter/material.dart';

class MotoreRicercaSentenze extends StatefulWidget {
  const MotoreRicercaSentenze({super.key});

  @override
  State<MotoreRicercaSentenze> createState() => _MotoreRicercaSentenzeState();
}

class _MotoreRicercaSentenzeState extends State<MotoreRicercaSentenze>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "tab 1"),
            Tab(text: "tab 2"),
            Tab(text: "tab 3"),
          ],
        ),
        Container(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: const [
              Text("tab 1 content"),
              Text("tab 2 content"),
              Text("tab 3 content"),
            ],
          ),
        ),
      ],
    );
  }
}
