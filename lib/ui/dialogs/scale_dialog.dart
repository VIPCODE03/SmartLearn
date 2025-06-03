import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';

class WdgScaleDialog extends StatefulWidget {
  final Widget? child;
  final bool barrierDismissible;
  final bool? shadow;
  final bool? border;
  final void Function()? onShow;

  const WdgScaleDialog({
    super.key,
    this.barrierDismissible = true,
    this.shadow,
    this.border,
    this.child,
    this.onShow
  });

  @override
  State<WdgScaleDialog> createState() => _WdgDialogState();
}

class _WdgDialogState extends State<WdgScaleDialog> {
  bool show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          show = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if(widget.onShow != null) {
        widget.onShow!();
      }
    });
  }

  void updateScreen() {
    if(context.mounted) {
      setState(() {});
    }
  }

  //=== Scale thu nhỏ trước khi pop ===
  Future<void> closeDialog() async {
    setState(() {
      show = false;
    });
    await Future.delayed(const Duration(milliseconds: 333));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if(widget.barrierDismissible) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: PopScope(
                canPop: widget.barrierDismissible,
                onPopInvokedWithResult: (a, c) async {
                  if(widget.barrierDismissible) {
                    await closeDialog();
                  }
                },
                child: AnimatedScale(
                  scale: show ? 1 : 0.3,
                  duration: const Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: (widget.border != null && widget.border!)
                                  ? Border.all(color: primaryColor(context), width: 0.5)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: (widget.shadow != null && widget.shadow!)
                                  ?
                              [
                                BoxShadow(
                                  color: primaryColor(context),
                                  offset: const Offset(0.06, 0.06),
                                  blurRadius: 4,
                                  spreadRadius: 0.4,
                                ),

                                BoxShadow(
                                  color: primaryColor(context),
                                  offset: const Offset(-0.06, -0.06),
                                  blurRadius: 4,
                                  spreadRadius: 0.4,
                                ),
                              ]
                                  : null
                          ),
                          padding: const EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () {},
                            child: widget.child
                          )
                      )),
                )
            )
        )
    );
  }
}