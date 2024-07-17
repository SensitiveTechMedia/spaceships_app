import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/color_helper.dart';

/// small Elevated Button
Widget getElevatedButton({
  required void Function() onTap,
  required String string,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(ColorCodes.green),
      overlayColor: MaterialStateProperty.all<Color>(ColorCodes.green),
      shadowColor: MaterialStateProperty.all<Color>(ColorCodes.green),
      minimumSize: MaterialStateProperty.all(Size(180, 55)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    child: Text(
      string,
      style: TextStyle(color: ColorCodes.white, fontSize: 16),
    ),
  );
}

/// large Elevated Button
Widget getElevatedButtonLarge({
  required void Function() onTap,
  required String string,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorCodes.green),
        overlayColor: MaterialStateProperty.all<Color>(ColorCodes.green),
        shadowColor: MaterialStateProperty.all<Color>(ColorCodes.green),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 55)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        string,
        style: TextStyle(color: ColorCodes.white, fontSize: 16),
      ),
    ),
  );
}

/// CircleAvtar
class CustomCircleAvtar extends StatelessWidget {
  const CustomCircleAvtar({
    super.key,
    this.backgroundColor,
    this.radius,
    this.child,
    this.foregroundColor,
    this.backgroundImage,
    this.foregroundImage,
  });
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? radius;
  final ImageProvider<Object>? backgroundImage;
  final ImageProvider<Object>? foregroundImage;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      foregroundImage: foregroundImage,
      foregroundColor: foregroundColor,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}

/// ElevatedButton
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    this.child,
    this.color,
    this.borderRadius = 10,
  });
  final void Function() onTap;
  final Widget? child;
  final Color? color;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          color ?? Theme.of(context).colorScheme.onPrimary,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          color ?? Theme.of(context).colorScheme.onPrimary,
        ),
        shadowColor: MaterialStateProperty.all<Color>(
          color ?? Theme.of(context).colorScheme.onPrimary,
        ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 55)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
      ),
      child: child,
    );
  }
}

/// Icon
class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.weight,
  });
  final IconData icon;
  final double? size;
  final Color? color;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      weight: weight,
    );
  }
}

/// text
class CustomText extends StatelessWidget {
  const CustomText({
    @override super.key,
    required this.text,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });
  final String text;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final int? maxLines;
  final FontStyle fontStyle = FontStyle.normal;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final Color color = fontColor ?? Get.theme.colorScheme.primary;
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
      ),
    );
  }
}

/// container

class CustomContainer extends Container {
  CustomContainer({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.containerPadding,
    this.containerMargin,
    this.containerChild,
  });
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? containerPadding;
  final EdgeInsets? containerMargin;
  final Widget? containerChild;
  @override
  Clip get clipBehavior => Clip.hardEdge;
  @override
  BoxConstraints? get constraints => (width != null || height != null)
      ? super.constraints?.tighten(width: width, height: height) ??
          BoxConstraints.tightFor(width: width, height: height)
      : null;
  @override
  EdgeInsets get padding => containerPadding ?? EdgeInsets.zero;
  @override
  EdgeInsets get margin => containerMargin ?? EdgeInsets.zero;
  @override
  Widget? get child => containerChild;
  @override
  BoxDecoration get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        color: backgroundColor ?? Get.theme.colorScheme.background,
      );
  @override
  Decoration get foregroundDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        border: (borderWidth == null)
            ? Border.all(
                color: borderColor ?? Get.theme.colorScheme.background,
                width: 1,
              )
            : (borderWidth == 0)
                ? null
                : Border.all(
                    color: borderColor ?? Get.theme.colorScheme.background,
                    width: borderWidth!,
                  ),
      );
}
