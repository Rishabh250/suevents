import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suevents/providers/theme_service.dart';

class CustomButton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final title;
  final textStyle;
  final onTap;

  const CustomButton(
      {required this.width,
      required this.height,
      required this.borderRadius,
      required this.onTap,
      required this.title,
      required this.textStyle});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: themeProvider.isDarkMode
                    ? const [
                        BoxShadow(
                          color: Color.fromARGB(255, 43, 42, 42),
                          offset: Offset(-4, -4),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(0, 199, 152, 1),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color.fromARGB(255, 207, 205, 205),
                          offset: Offset(5, 5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]),
            child: Center(
              child: Text(
                widget.title,
                style: widget.textStyle,
              ),
            ),
          ),
        ));
  }
}

class OverlayCustomButton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final title;
  final textStyle;
  final onTap;

  const OverlayCustomButton(
      {required this.width,
      required this.height,
      required this.borderRadius,
      required this.onTap,
      required this.title,
      required this.textStyle});

  @override
  _OverlayCustomButtonState createState() => _OverlayCustomButtonState();
}

class _OverlayCustomButtonState extends State<OverlayCustomButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: themeProvider.isDarkMode
                      ? const [
                          BoxShadow(
                            color: Color.fromARGB(255, 43, 42, 42),
                            offset: Offset(-4, -4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 20, 20, 20),
                            offset: Offset(4, 4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [
                          const BoxShadow(
                            color: Color.fromARGB(255, 207, 205, 205),
                            offset: Offset(5, 5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 22, 116, 10),
                            Color.fromARGB(255, 18, 73, 10)
                          ]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: widget.textStyle,
                    ),
                  ),
                ),
              ),
            )));
  }
}

class CustomIconButton extends StatefulWidget {
  final double width;
  final double hieght;
  final double borderRadius;
  final icon;
  final onTap;

  const CustomIconButton({
    required this.width,
    required this.hieght,
    required this.borderRadius,
    required this.onTap,
    required this.icon,
  });

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
        width: widget.width,
        height: widget.hieght,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: themeProvider.isDarkMode
                    ? const [
                        BoxShadow(
                          color: Color.fromARGB(255, 43, 42, 42),
                          offset: Offset(-4, -4),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 20, 20, 20),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color.fromARGB(255, 207, 205, 205),
                          offset: Offset(5, 5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]),
            child: Center(child: widget.icon),
          ),
        ));
  }
}

class OverlayCustomImage extends StatefulWidget {
  final double width;
  final double hieght;
  final double borderRadius;
  final Image image;

  const OverlayCustomImage({
    required this.width,
    required this.hieght,
    required this.borderRadius,
    required this.image,
  });

  @override
  _OverlayCustomImageState createState() => _OverlayCustomImageState();
}

class _OverlayCustomImageState extends State<OverlayCustomImage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      width: widget.width,
      height: widget.hieght,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: themeProvider.isDarkMode
                ? const [
                    BoxShadow(
                      color: Color.fromARGB(255, 43, 42, 42),
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 20, 20, 20),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color.fromARGB(255, 207, 205, 205),
                      offset: Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                gradient: themeProvider.isDarkMode
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            Color.fromARGB(255, 22, 116, 10),
                            Color.fromARGB(255, 18, 73, 10)
                          ])
                    : null,
                border: themeProvider.isDarkMode
                    ? null
                    : Border.all(
                        width: 2,
                        color: const Color.fromARGB(255, 22, 116, 10)),
                borderRadius: BorderRadius.circular(30)),
            child: Center(child: widget.image),
          ),
        ),
      ),
    );
  }
}

class CustomNaviButtom extends StatefulWidget {
  final double width;
  final double hieght;
  final double borderRadius;
  final Image image;

  const CustomNaviButtom({
    required this.width,
    required this.hieght,
    required this.borderRadius,
    required this.image,
  });

  @override
  _CustomNaviButtomState createState() => _CustomNaviButtomState();
}

class _CustomNaviButtomState extends State<CustomNaviButtom> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      width: widget.width,
      height: widget.hieght,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: themeProvider.isDarkMode
                ? const [
                    BoxShadow(
                      color: Color.fromARGB(255, 43, 42, 42),
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 20, 20, 20),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color.fromARGB(255, 207, 205, 205),
                      offset: Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: widget.image),
        ),
      ),
    );
  }
}
