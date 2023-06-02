import 'package:creatego_packages/creatego_packages.dart';
import 'package:design_grid/design_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';

class VirtualGridBlock extends StatefulWidget {
  const VirtualGridBlock({super.key});

  @override
  State<VirtualGridBlock> createState() => _VirtualGridBlockState();
}

class _VirtualGridBlockState extends State<VirtualGridBlock> {
  @override
  Widget build(BuildContext context) {
    return CreategoReduxStoreConnector<CreategoAppState,
            VirtualLayoutBlockState>(
        converter: (store) => store.state.virtualLayoutBlockState,
        builder: (context, state) {
          final controller = state.dashboardController;
          final width = state.blockSize.width;
          final height = state.blockSize.height;

          return RepaintBoundary(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Virtual Grid"),
                actions: [
                  IconButton(
                      tooltip: "Enable edit mode",
                      onPressed: () {
                        controller.isEditing = !controller.isEditing;
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      tooltip: "Set Block Size",
                      onPressed: () =>
                          _showSetBlockSizeDialog(context, width, height),
                      icon: const Icon(Icons.photo_size_select_large_sharp)),
                ],
              ),
              body: SizedBox(
                width: width,
                height: height,
                child: ResponsiveDesignGridConfig(
                  theme: const ResponsiveDesignGridThemeData(
                    columns: 10,
                    gridPadding: 0,
                    columnSpacing: 30, // mentioned as [gutter] in figma
                  ),
                  child: ResponsiveDesignGridDebugOverlay(
                    enableControls: kDebugMode,
                    child: ResponsiveDesignGrid(
                      children: [
                        ResponsiveDesignGridRow(children: [
                          ResponsiveDesignGridItem(
                            columns:
                                const ResponsiveDesignGridColumns(small: 12),
                            child: Container(
                              color: Colors.grey[300],
                              width: width,
                              height: height,
                              child: Dashboard<BlockLayoutItemModel>(
                                horizontalSpace: 0,
                                verticalSpace: 0,
                                slotCount: width ~/ 10,
                                editModeSettings: EditModeSettings(
                                  panEnabled: true,
                                  backgroundStyle:
                                      const EditModeBackgroundStyle(
                                    dualLineHorizontal: false,
                                    dualLineVertical: false,
                                    lineWidth: .2,
                                    fillColor: Colors.transparent,
                                    lineColor: Colors.pinkAccent,
                                  ),
                                  resizeCursorSide: 10,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkToPlace: false,
                                animateEverytime: false,
                                slideToTop: false,
                                itemBuilder: (item) {
                                  return DashboardItemWidget(
                                    item: item,
                                    child: RepaintBoundary(
                                      child: item.child,
                                    ),
                                  );
                                },
                                dashboardItemController:
                                    state.dashboardController,
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showSetBlockSizeDialog(
      BuildContext context, double width, double height) {
    double? w = width;
    double? h = height;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Set Block Size"),
            content: Material(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 50, child: Text("Width: ")),
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: width.toString()),
                          onChanged: (value) {
                            w = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 50, child: Text("Height: ")),
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: height.toString()),
                          onChanged: (value) {
                            h = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    CreategoStore.dispatch(
                        SetBlockSizeAction(width: w, height: h));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }
}
