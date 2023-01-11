import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../flutter_quill.dart' hide Text;

class ScriptTextSpan extends TextSpan {
  ScriptTextSpan({
    required bool isSuperscript,
    required String text,
    required TextStyle textStyle,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
  }) : super(
          recognizer: recognizer,
          mouseCursor: mouseCursor,
          children: [
            ...text.split('').toList().asMap().entries.map(
                  (e) => WidgetSpan(
                    child: Transform.translate(
                      offset: _getOffset(isSuperscript, textStyle),
                      child: Text(
                        e.key == 0 ? ' ${e.value}' : e.value,
                        style: textStyle.copyWith(
                            fontSize: _getFontSize(textStyle) * _textScale),
                      ),
                    ),
                  ),
                ),
          ],
        );
}

const _textScale = 0.7;

double _getFontSize(TextStyle textStyle) {
  return textStyle.fontSize ?? DefaultStyles.defaultFontSize;
}

Offset _getOffset(bool isSuperscript, TextStyle textStyle) {
  final fontSize = _getFontSize(textStyle);
  final percentY = isSuperscript ? -0.3 : 0.2;
  return Offset(0, percentY * fontSize);
}
