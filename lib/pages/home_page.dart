import 'package:creatego_packages/creatego_packages.dart';
import 'package:flutter/material.dart';

final ValueNotifier<IWidget?> _selectedWidget = ValueNotifier(null);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: _WidgetList()),
          const Expanded(flex: 3, child: _WidgetPreview()),
          const Expanded(flex: 1, child: _WidgetResources()),
        ],
      ),
    );
  }
}

class _WidgetList extends StatelessWidget {
  _WidgetList({Key? key}) : super(key: key);

  final List<IWidget> _coreWidgets = [
    CustomButton(),
    CustomContainer(),
    CustomDivider(),
    CustomIcon(),
    CustomImage(),
    CustomInputField(),
    CustomPadding(),
    CustomSingleChildScrollView(),
    CustomText(),
    CustomRow(),
    CustomColumn(),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border(
            right: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final widget in _coreWidgets)
                InkWell(
                    onTap: () {
                      _selectedWidget.value = widget;
                    },
                    child: widget.build(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WidgetPreview extends StatelessWidget {
  const _WidgetPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: ValueListenableBuilder(
        valueListenable: _selectedWidget,
        builder: (ctx, value, ch) {
          if (value == null) {
            return const Text("Select a widget");
          }
          return value.build(context);
        },
      ),
    );
  }
}

class _WidgetResources extends StatelessWidget {
  const _WidgetResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border(
            left: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: _selectedWidget,
            builder: (ctx, value, ch) {
              if (value == null) {
                return const Text("Select a widget");
              }
              return Wrap(
                runSpacing: 24,
                spacing: 8,
                children: [
                  ...value.resources,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
