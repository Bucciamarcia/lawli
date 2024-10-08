import 'package:flutter/material.dart';
import 'package:lawli/services/firestore.dart';
import 'package:lawli/template/nuovo/nuovo_modello_button.dart';
import 'package:lawli/template/template_list.dart';
import 'package:provider/provider.dart';
import 'dropdown_selector_pratica.dart';
import 'provider.dart';

class TemplateHomeWidget extends StatelessWidget {
  const TemplateHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AnimatedVideoSwitcher(),
        SizedBox(
          height: 20,
        ),
        InputRow(),
        SizedBox(
          height: 20,
        ),
        TemplateList(),
      ],
    );
  }
}

class AnimatedVideoSwitcher extends StatefulWidget {
  const AnimatedVideoSwitcher({super.key});

  @override
  State<AnimatedVideoSwitcher> createState() => _AnimatedVideoSwitcherState();
}

class _AnimatedVideoSwitcherState extends State<AnimatedVideoSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: Provider.of<TemplateProvider>(context, listen: true)
                  .selectedPratica ==
              null
          ? const Center(
            child: SizedBox(
                key: ValueKey('video'),
                width: 400,
                height: 250,
                child: Placeholder(),
              ),
          )
          : const SizedBox(
              key: ValueKey('novideo'),
              width: 1,
              height: 1,
            ),
    );
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FutureBuilder(
          future: RetrieveObjectFromDb().getPratiche(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Errore");
            } else {
              return DropdownSelectorPratica(snapshot: snapshot);
            }
          },
        ),
        const NuovoModelloButton(),
      ],
    );
  }
}
