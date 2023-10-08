// Flutter imports:
import 'package:flutter/material.dart';

class LifecycleManager extends StatefulWidget {
  const LifecycleManager({
    required this.child, required this.lifeCycle, super.key,
  });

  final Widget child;
  final Function(AppLifecycleState) lifeCycle;

  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.lifeCycle(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
