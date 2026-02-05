import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/shared/components/custom_action_button.dart';

class CustomTable extends StatefulWidget {
  final List<dynamic> data;
  final List<ColumnModel> Function(dynamic item, BoxConstraints constraints) columns;
  final Function(dynamic item)? onTap;
  final Function(dynamic item)? onDoubleTap;

  const CustomTable({
    super.key,
    required this.data,
    required this.columns,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final _horizontalHeaderController = ScrollController();

  final _horizontalBodyController = ScrollController();
  final _verticalBodyController = ScrollController();

  late List<ColumnModel> columns;

  static const double headerRowHeight = 28;
  static const double bodyRowHeight = 20;

  static const Color headerRowColor = Color(0xFFDDDEDF);
  static const Color evenRowColor = Colors.white;
  static const Color oddRowColor = Color(0xffeeeff0);

  // @override
  // void initState() {
  //   super.initState();

  //   columns = widget.columns(null);
  // }

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalBodyController.dispose();

    super.dispose();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    final platform = defaultTargetPlatform.name;
    if (platform != 'android' && platform != 'iOS') return;

    double offset = _horizontalHeaderController.offset - details.delta.dx;
    if (offset < 0) {
      offset = 0;
    } else if (offset > _horizontalHeaderController.position.maxScrollExtent) {
      offset = _horizontalHeaderController.position.maxScrollExtent;
    }

    _horizontalHeaderController.jumpTo(offset);
    _horizontalBodyController.jumpTo(offset);
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    final platform = defaultTargetPlatform.name;
    if (platform != 'android' && platform != 'iOS') return;

    double offset = _verticalBodyController.offset - details.delta.dy;
    if (offset < 0) {
      offset = 0;
    } else if (offset > _verticalBodyController.position.maxScrollExtent) {
      offset = _verticalBodyController.position.maxScrollExtent;
    }

    _verticalBodyController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      columns = widget.columns(null, constraints);

      return Column(
        children: [
          Listener(
            onPointerMove: (event) {
              final platform = defaultTargetPlatform.name;
              if (platform != 'android' && platform != 'iOS') return;

              // if (scrollVertically) {
              //   double offset =
              //       _verticalBodyController.offset - event.delta.dy;
              //   if (offset < 0) {
              //     offset = 0;
              //   } else if (offset >
              //       _verticalBodyController.position.maxScrollExtent) {
              //     offset = _verticalBodyController.position.maxScrollExtent;
              //   }
              //   _verticalBodyController.jumpTo(offset);
              // }

              double offset = _horizontalHeaderController.offset - event.delta.dx;
              if (offset < 0) {
                offset = 0;
              } else if (offset > _horizontalHeaderController.position.maxScrollExtent) {
                offset = _horizontalHeaderController.position.maxScrollExtent;
              }

              _horizontalHeaderController.jumpTo(offset);
              _horizontalBodyController.jumpTo(offset);
            },
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                double offset = _horizontalHeaderController.offset + event.scrollDelta.dy;
                if (offset < 0) {
                  offset = 0;
                } else if (offset > _horizontalHeaderController.position.maxScrollExtent) {
                  offset = _horizontalHeaderController.position.maxScrollExtent;
                }

                _horizontalHeaderController.jumpTo(offset);
                _horizontalBodyController.jumpTo(offset);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalHeaderController,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: columns
                          .where((e) => e.actions == null)
                          .map((e) => Container(
                                alignment: e.alignment,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black26,
                                      width: 0,
                                    ),
                                  ),
                                  color: headerRowColor,
                                ),
                                height: headerRowHeight,
                                width: e.width,
                                child: e.checkbox ??
                                    Text(
                                      e.label,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.clip,
                                      ),
                                      maxLines: 1,
                                    ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final action = columns.firstWhere((e) => e.actions != null);

                    return Container(
                      alignment: action.alignment,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black26,
                            width: 0,
                          ),
                        ),
                        color: headerRowColor,
                      ),
                      height: headerRowHeight,
                      width: action.width,
                      child: Text(action.label),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              onVerticalDragUpdate: onVerticalDragUpdate,
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    double offset = _verticalBodyController.offset + event.scrollDelta.dy;
                    if (offset < 0) {
                      offset = 0;
                    } else if (offset > _verticalBodyController.position.maxScrollExtent) {
                      offset = _verticalBodyController.position.maxScrollExtent;
                    }

                    _verticalBodyController.jumpTo(offset);
                  }
                },
                child: SingleChildScrollView(
                  controller: _verticalBodyController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ...widget.data.asMap().entries.map((item) {
                        final bodyColumn = widget.columns(item.value, constraints);

                        return InkWell(
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(item.value);
                            }
                          },
                          onDoubleTap: () {
                            if (widget.onDoubleTap != null) {
                              widget.onDoubleTap!(item.value);
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _horizontalBodyController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: bodyColumn
                                        .where((e) => e.actions == null)
                                        .map((e) => Container(
                                              alignment: e.alignment,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: item.key + 1 == widget.data.length
                                                      ? BorderSide.none
                                                      : const BorderSide(
                                                          color: Colors.black26,
                                                          width: 0,
                                                        ),
                                                ),
                                                color: item.key % 2 == 0 ? evenRowColor : oddRowColor,
                                              ),
                                              height: bodyRowHeight,
                                              width: e.width,
                                              child: e.checkbox ??
                                                  (e.value is Widget
                                                      ? e.value
                                                      : Text(
                                                          e.value.toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        )),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final action = bodyColumn.firstWhere((e) => e.actions != null);

                                  return Container(
                                    alignment: action.alignment,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: item.key + 1 == widget.data.length
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.black26,
                                                width: 0,
                                              ),
                                      ),
                                      color: item.key % 2 == 0 ? evenRowColor : oddRowColor,
                                    ),
                                    height: bodyRowHeight,
                                    width: action.width,
                                    // child: Text(action.label),
                                    child: MenuAnchor(
                                      alignmentOffset: const Offset(-35, 0),
                                      style: const MenuStyle(
                                        // shape: WidgetStatePropertyAll(),
                                        // side: WidgetStatePropertyAll(BorderSide.none),
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                      ),
                                      builder: (context, controller, child) {
                                        return CustomActionButton(
                                          function: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          icon: Icons.more_horiz_rounded,
                                          mainColor: const Color.fromRGBO(0, 0, 0, .6),
                                          bgColor: const Color.fromRGBO(0, 0, 0, .1),
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                        );
                                      },
                                      menuChildren: action.actions!,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(color: Colors.black26, height: 0, thickness: 0),
        ],
      );
    });
  }
}

class ColumnModel {
  final String label;
  final dynamic value;
  final double width;
  final AlignmentGeometry alignment;
  final List<Widget>? actions;
  final Widget? checkbox;

  ColumnModel({
    required this.label,
    required this.value,
    required this.width,
    required this.alignment,
    this.actions,
    this.checkbox,
  });
}
