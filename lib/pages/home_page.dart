import 'package:creatego_packages/creatego_packages.dart';
import 'package:flutter/material.dart';

import '../block_virtual_layout/block_virtual_layout.dart';

final ValueNotifier<IWidget?> _selectedWidget = ValueNotifier(null);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _selectedWidget,
        builder: (context, value, child) => Visibility(
          visible: value != null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                tooltip: "Add",
                onPressed: () {
                  _selectedWidget.value = null;
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                tooltip: "Remove",
                onPressed: () {
                  _selectedWidget.value = null;
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: const [
          Expanded(flex: 1, child: _WidgetList()),
          Expanded(flex: 3, child: _WidgetPreview()),
          Expanded(flex: 1, child: _WidgetResources()),
        ],
      ),
    );
  }
}

class _WidgetList extends StatelessWidget {
  const _WidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreategoReduxStoreConnector<CreategoAppState,
            VirtualLayoutBlockState>(
        converter: (store) => store.state.virtualLayoutBlockState,
        builder: (context, state) {
          final controller = state.dashboardController;
          final width = state.blockSize.width;
          final height = state.blockSize.height;
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
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final widget in coreWidgets)
                      widgetMapper(
                            widget,
                            () {
                              if (controller.isEditing) return;
                              final id =
                                  BlockLayoutItemModel.generateIdentifier();
                              final gestureDetector = CustomGestureDetector()
                                  .copy() as CustomGestureDetector;
                              gestureDetector.setOnTap(CustomSimpleAction(() {
                                CreategoStore.dispatch(SelectBlockAction(id));
                              }));
                              gestureDetector.setChild(widget);
                              controller.addItem(
                                BlockLayoutItemModel(
                                  child: gestureDetector,
                                  identifier: id,
                                  width: width ~/ 80,
                                  height: height ~/ 120,
                                ),
                              );
                            },
                          ) ??
                          const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _WidgetPreview extends StatelessWidget {
  const _WidgetPreview({Key? key}) : super(key: key);

  // double height(BuildContext context, double screenHeight, double value) =>
  //     (MediaQuery.of(context).size.height / [designHieght]1920) * [value]80;

  @override
  Widget build(BuildContext context) {
    return const VirtualGridBlock();
  }
}

class _WidgetResources extends StatelessWidget {
  const _WidgetResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreategoReduxStoreConnector<CreategoAppState,
            VirtualLayoutBlockState>(
        onInit: (store) {
          // store.state.virtualLayoutBlockState.dashboardController.delete(
          //     store.state.virtualLayoutBlockState.items.first.identifier);
          // CreategoStore.dispatch(SelectBlockAction(null));
        },
        converter: (store) => store.state.virtualLayoutBlockState,
        builder: (context, state) {
          final controller = state.dashboardController;
          final selected = state.selectedItem;
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
                    if (selected == null) {
                      return const Text("Select a widget");
                    }
                    return ListView(
                      padding: const EdgeInsets.only(right: 16),
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  CreategoStore.dispatch(
                                      SelectBlockAction(null));
                                },
                                icon: const Icon(Icons.close)),
                            IconButton(
                                onPressed: () {
                                  if (state.selectedItem == null) return;
                                  controller
                                      .delete(state.selectedItem!.identifier);
                                  CreategoStore.dispatch(
                                      SelectBlockAction(null));
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                        ...selected.child.resources.map(
                          (e) => Column(
                            children: [
                              e,
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
