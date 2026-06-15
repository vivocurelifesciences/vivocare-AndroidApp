import 'package:flutter/widgets.dart';

/// Width (in logical pixels) below which the app renders its phone-optimized
/// ("mobile") layout. At or above this width the existing tablet layout is used
/// unchanged — 600 is Material 3's compact→medium window-class boundary, so
/// phones (portrait ~360–430, landscape up to ~900 but classified by shortest
/// side via width here) get the mobile treatment while tablets do not.
const double kMobileBreakpoint = 600;

extension ResponsiveContext on BuildContext {
  /// True on phone-sized screens. Tablet layouts must not branch on this.
  bool get isMobile => MediaQuery.sizeOf(this).width < kMobileBreakpoint;

  Size get screenSize => MediaQuery.sizeOf(this);

  /// A dialog body size that fits phones while leaving tablet sizes untouched.
  /// On tablets returns [tabletWidth]×[tabletHeight]; on phones it shrinks to
  /// the available screen with comfortable margins.
  Size dialogSize({required double tabletWidth, required double tabletHeight}) {
    final Size screen = MediaQuery.sizeOf(this);
    if (screen.width >= kMobileBreakpoint) {
      return Size(tabletWidth, tabletHeight);
    }
    final double width = screen.width - 48;
    final double height = (screen.height * 0.7).clamp(320.0, tabletHeight);
    return Size(width.clamp(280.0, tabletWidth), height);
  }
}
