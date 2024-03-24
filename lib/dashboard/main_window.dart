import 'package:flutter/material.dart';
import 'package:lawli/services/services.dart';
import "widgets.dart";
import "package:lawli/shared/chat_widget.dart";

class MainWindow extends StatelessWidget {
  const MainWindow({
    super.key,
    required this.pratica,
  });

  final Pratica pratica;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: ResponsiveLayout.mainWindowPadding(context),
          child: Column(
            children: [
              Text(
                pratica.titolo,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              const ExpandableOverview(
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 600,
                  child: Row(
                    children: [
                      Documenti(pratica: pratica),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const ChatView(),
                        ),
                      ),
                    ],
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
