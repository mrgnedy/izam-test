import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PageDirection { vertical, horizontal, free }

extension FlexExt on Flex {
  Widget separated({Widget? separator, double? separateBy}) {
    return Flex(
      direction: direction,
      clipBehavior: clipBehavior,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: List.generate(
        children.length,
        (index) => Flex(
          direction: direction,
          clipBehavior: clipBehavior,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          textBaseline: textBaseline,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          children: [
            children[index],
            // Expanded(child: children[index]),
            if (index < children.length - 1)
              separator ??
                  SizedBox(
                    height:
                        direction == Axis.horizontal ? 0 : separateBy ?? 8.h,
                    width: direction == Axis.vertical ? 0 : separateBy ?? 8.w,
                  ),
          ],
        ),
      ),
    );
  }
}

extension ObjExt<T> on T {
  MaterialStateProperty<T> get materialPro =>
      MaterialStateProperty.all<T>(this);

  List<T> generate(int count) => List.generate(count, (index) => this);
}

extension OffsetExtensions on Offset {
  ///Returns the absolute distance between two given offsets
  double operator <<(Offset o) {
    final dx = this.dx - o.dx;
    final dy = this.dy - o.dy;
    final dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    return dist;
  }

  ///Returns the offset relative to screen dimentions
  Offset get toResp => Offset(dx * 1.sw, dy * 1.sh);
 

  ///Returns a given offset without the sign if negative
  Offset get abs => Offset(dx.abs(), dy.abs());
  clamp(Offset min, Offset max) {
    if (this > max) return max;

    if (this < min) return min;
    return this;
  }
}

class OffsetLong extends Offset {
  ///Same functionality as Offset but toString returns the offset without rounding
  OffsetLong(double dx, double dy) : super(dx, dy);

  @override
  String toString() => 'Offset($dx, $dy)';
}

extension ListExtensions on List {
  operator [](int index) {
    if (this == null || this.length <= index) {
      print("Max Index is ${this.length - 1}");
      return null;
    } else
      return this[index];
  }

  // List get reverse => this.reversed
}

_setOrientation(PageDirection direction) {
  switch (direction) {
    case PageDirection.vertical:
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      break;
    case PageDirection.horizontal:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      break;
    case PageDirection.free:
      break;
  }
}

extension WidgetExt on Widget {
  MaterialPageRoute _materialRoute([name, arguments]) => MaterialPageRoute(
        // pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
        //   opacity: animation,
        //   child: this,
        // ),
        builder: (context) => this,
        settings: RouteSettings(name: '$name', arguments: arguments),
      );
  PageRoute _pageRoute([name, arguments]) => NoAnimationPageRoute(
        builder: (
          context,
        ) =>
            this,
        settings: RouteSettings(name: "$name", arguments: arguments),
        // transitionDuration: 0.s,
        // reverseTransitionDuration: 0.s,
      );

  Future pushNamed(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.pushNamed(
      context,
      name,
      arguments: arguments,
      // isMaterial
      //     ? this._materialRoute(name, arguments)
      //     : this._pageRoute(name, arguments),
    );
  }

  Future push(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.push(
      context,
      isMaterial
          ? _materialRoute(name, arguments)
          : _pageRoute(name, arguments),
    );
  }

  Future pushReplace(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) async {
    _setOrientation(direction);
    if (direction != PageDirection.free) await Future.delayed(00.ms);
    Navigator.pushReplacement(
      context,
      isMaterial
          ? _materialRoute(name, arguments)
          : _pageRoute(name, arguments),
    );
  }

  Future pushAndRemoveAll(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) async {
    _setOrientation(direction);
    if (direction != PageDirection.free) await Future.delayed(00.ms);
    Navigator.pushAndRemoveUntil(
      context,
      isMaterial
          ? _materialRoute(name, arguments)
          : _pageRoute(name, arguments),
      (route) => false,
    );
  }

  void popUntil(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    Navigator.popUntil(context, ModalRoute.withName(name));
  }
}

extension ContextExtension on BuildContext {
  Offset getOffset() {
    final renderBox = this.findRenderObject() as RenderBox;
    final overlay = Overlay.of(this).context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(
      renderBox.size.center(Offset.zero),
      ancestor: overlay,
    );
  }

  Orientation get orientation => MediaQuery.of(this).orientation;

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width; 
  void pop([result]) => Navigator.pop(this, result);
  void popUntil(String name) =>
      Navigator.popUntil(this, ModalRoute.withName(name)); 
}

extension DateTimeExt on DateTime {
  bool operator >(DateTime s) => this.isAfter(s);
  bool operator <(DateTime s) => this.isBefore(s);
}

extension IntToDur on int {
  Duration get s => Duration(seconds: this);
  Duration get hr => Duration(hours: this);
  Duration get m => Duration(minutes: this);
  Duration get ms => Duration(milliseconds: this);
}

extension NumExt on num {
  SizedBox get vPad => SizedBox(height: this+0.0);
  SizedBox get hPad => SizedBox(width: this+0.0);
  SizedBox get allPad => SizedBox(width: this+0.0, height: this+0.0,);

  EdgeInsets get p => EdgeInsets.all(this + 0.0);
  EdgeInsets get padT => EdgeInsets.only(top: this + 0.0);
  EdgeInsets get padB => EdgeInsets.only(bottom: this + 0.0);
  EdgeInsets get padL => EdgeInsets.only(left: this + 0.0);
  EdgeInsets get padR => EdgeInsets.only(right: this + 0.0);

  EdgeInsetsDirectional get padS =>
      EdgeInsetsDirectional.only(start: this + 0.0);
  EdgeInsetsDirectional get padE => EdgeInsetsDirectional.only(end: this + 0.0);
  EdgeInsetsDirectional get padD => EdgeInsetsDirectional.all(this + 0.0);

  EdgeInsets get padH => EdgeInsets.symmetric(horizontal: this + 0.0);
  EdgeInsets get padV => EdgeInsets.symmetric(vertical: this + 0.0);

  BorderRadius get brc => BorderRadius.circular(toDouble());

  double get sf => this + 0.02.sw;
  double get tf {
    final shortSide = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .size
        .shortestSide;

    if (shortSide > 800)
      return 1.55 * this;
    else if (shortSide < 600)
      return 1.0 * this;
    else
      return 1.25 * this;
  } 
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject?.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}


class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
