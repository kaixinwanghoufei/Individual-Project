import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MouseTouchWorkshopPage(),
    );
  }
}

class MouseTouchWorkshopPage extends StatefulWidget {
  const MouseTouchWorkshopPage({super.key});

  @override
  State<MouseTouchWorkshopPage> createState() => _MouseTouchWorkshopPageState();
}

class _MouseTouchWorkshopPageState extends State<MouseTouchWorkshopPage> {
  bool _hovering = false;
  int _navIndex = 0;
  final FocusNode _focusNode = FocusNode();

  void _showActivatedSnackBar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Activated 🎉'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = (kIsWeb && _hovering)
        ? Colors.grey
        : const Color(0xFF1E88E5);
    final double width = MediaQuery.of(context).size.width;
    final bool useRail = width >= 600;
    final String label = _navIndex == 1
        ? 'BOARD Action'
        : _navIndex == 2
        ? 'SETTINGS Action'
        : 'Hover or Tap Me\n(Mouse / Touch)';

    return Scaffold(
      backgroundColor: const Color(0xFFF7EEF7),
      appBar: AppBar(
        title: const Text('Mouse & Touch Workshop'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: _navIndex,
              onDestinationSelected: (i) => setState(() => _navIndex = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'HOME',
                ),
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'BOARD',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'SETTINGS',
                ),
              ],
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool wide = constraints.maxWidth >= 1024;

            Widget responsiveContent;
            if (wide) {
              responsiveContent = GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  Center(
                    child: Focus(
                      autofocus: kIsWeb,
                      child: KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              (event.logicalKey == LogicalKeyboardKey.enter ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.space)) {
                            _showActivatedSnackBar();
                          }
                        },
                        child: _InteractiveButton(
                          isWeb: kIsWeb,
                          color: buttonColor,
                          onHoverChanged: (v) => setState(() => _hovering = v),
                          onTap: _showActivatedSnackBar,
                          label: label,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              responsiveContent = ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Focus(
                      autofocus: kIsWeb,
                      child: KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              (event.logicalKey == LogicalKeyboardKey.enter ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.space)) {
                            _showActivatedSnackBar();
                          }
                        },
                        child: _InteractiveButton(
                          isWeb: kIsWeb,
                          color: buttonColor,
                          onHoverChanged: (v) => setState(() => _hovering = v),
                          onTap: _showActivatedSnackBar,
                          label: label,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (useRail) {
              return Row(
                children: [
                  NavigationRail(
                    selectedIndex: _navIndex,
                    onDestinationSelected: (i) => setState(() => _navIndex = i),
                    labelType: wide
                        ? NavigationRailLabelType.selected
                        : NavigationRailLabelType.none,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('home page'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: Text('board'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('settings'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: responsiveContent),
                ],
              );
            }
            return responsiveContent;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

/// 把 Web / Mobile 的交互分开做：
/// - Web：MouseRegion 负责 hover；GestureDetector 负责 click
/// - Mobile：只用 GestureDetector
class _InteractiveButton extends StatelessWidget {
  const _InteractiveButton({
    required this.isWeb,
    required this.color,
    required this.onHoverChanged,
    required this.onTap,
    required this.label,
  });

  final bool isWeb;
  final Color color;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double btnWidth;
    double btnHeight;
    double textSize;
    if (screenWidth < 600) {
      btnWidth = 240;
      btnHeight = 64;
      textSize = 16;
    } else if (screenWidth < 1024) {
      btnWidth = 340;
      btnHeight = 84;
      textSize = 18;
    } else {
      btnWidth = 420;
      btnHeight = 100;
      textSize = 20;
    }

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: btnWidth,
      height: btnHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    // ✅ Mobile：按要求用 GestureDetector
    if (!isWeb) {
      return GestureDetector(onTap: onTap, child: button);
    }

    // ✅ Web：Hover + Click
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: button),
    );
  }
}
