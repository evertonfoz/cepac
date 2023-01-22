import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlutterFlowCheckboxGroup extends StatefulWidget {
  const FlutterFlowCheckboxGroup({
    this.initiallySelected,
    required this.options,
    required this.onChanged,
    required this.textStyle,
    this.labelPadding,
    this.itemPadding,
    required this.activeColor,
    required this.checkColor,
    this.checkboxBorderRadius,
    required this.checkboxBorderColor,
    this.initialized = true,
    this.selectedValuesVariable,
  });

  final List<String>? initiallySelected;
  final List<String> options;
  final void Function(List<String>)? onChanged;
  final TextStyle textStyle;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Color activeColor;
  final Color checkColor;
  final BorderRadius? checkboxBorderRadius;
  final Color checkboxBorderColor;
  final bool initialized;
  final ValueNotifier<List<String>?>? selectedValuesVariable;

  @override
  State<FlutterFlowCheckboxGroup> createState() =>
      _FlutterFlowCheckboxGroupState();
}

class _FlutterFlowCheckboxGroupState extends State<FlutterFlowCheckboxGroup> {
  late List<String> checkboxValues;
  ValueListenable<List<String>?>? get changeSelectedValues =>
      widget.selectedValuesVariable;
  List<String>? get selectedValues => widget.selectedValuesVariable?.value;

  @override
  void initState() {
    super.initState();
    checkboxValues = widget.initiallySelected ?? [];
    if (!widget.initialized && checkboxValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(checkboxValues);
          }
        },
      );
    }
    changeSelectedValues?.addListener(() {
      if (widget.selectedValuesVariable != null &&
          selectedValues != null &&
          checkboxValues != selectedValues) {
        setState(() => checkboxValues = List.from(selectedValues!));
      }
    });
  }

  @override
  void dispose() {
    changeSelectedValues?.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final option = widget.options[index];
          final selected = checkboxValues.contains(option);
          return Theme(
            data: ThemeData(unselectedWidgetColor: widget.checkboxBorderColor),
            child: Padding(
              padding: widget.itemPadding ?? EdgeInsets.zero,
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: widget.onChanged != null
                        ? (isSelected) {
                            if (isSelected == null) {
                              return;
                            }
                            isSelected
                                ? checkboxValues.add(option)
                                : checkboxValues.remove(option);
                            widget.onChanged!(checkboxValues);
                            setState(() {});
                          }
                        : null,
                    activeColor: widget.activeColor,
                    checkColor: widget.checkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          widget.checkboxBorderRadius ?? BorderRadius.zero,
                    ),
                  ),
                  Padding(
                    padding: widget.labelPadding ?? EdgeInsets.zero,
                    child: Text(
                      widget.options[index],
                      style: widget.textStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
