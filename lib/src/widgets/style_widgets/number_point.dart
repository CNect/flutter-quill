// import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../flutter_quill.dart' hide Text;

import '../text_block.dart';

enum QuillIndentStyle {
  number,
  letter,
  roman,
}

class QuillNumberPoint extends StatelessWidget {
  const QuillNumberPoint({
    required this.blockIndex,
    required this.indentStyles,
    required this.line,
    required this.index,
    required this.sameIndentIndex,
    required this.indentLevelCounts,
    required this.count,
    required this.style,
    required this.width,
    required this.attrs,
    this.withDot = true,
    this.padding = 0.0,
    Key? key,
  }) : super(key: key);

  final int blockIndex;
  final List<QuillIndentStyle> indentStyles;
  final Line line;
  final int index;
  final int sameIndentIndex;
  final Map<int?, int> indentLevelCounts;
  final int count;
  final TextStyle style;
  final double width;
  final Map<String, Attribute> attrs;
  final bool withDot;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final suffix = withDot ? '.' : '';
    final indentStyles =
        this.indentStyles.isEmpty ? QuillIndentStyle.values : this.indentStyles;
    final n = sameIndentIndex + index;
    final hasIndentAttribute = attrs.containsKey(Attribute.indent.key);

    int? level = 0;

    if (!hasIndentAttribute && !indentLevelCounts.containsKey(1)) {
      // log('$sameIndentIndex ($index/${this.count})...$n');
      indentLevelCounts.clear();
      final s = _formatIndentStyle(n, indentStyles.first);
      return Container(
        alignment: AlignmentDirectional.topEnd,
        width: width,
        padding: EdgeInsetsDirectional.only(end: padding),
        child: Text(
          '$s$suffix',
          style: style,
        ),
      );
    }

    if (hasIndentAttribute) {
      level = attrs[Attribute.indent.key]!.value;
    } else {
      // first level but is back from previous indent level
      // supposed to be "2."
      indentLevelCounts[0] = 1;
    }
    if (indentLevelCounts.containsKey(level! + 1)) {
      // last visited level is done, going up
      indentLevelCounts.remove(level + 1);
    }
    final count = (indentLevelCounts[level] ?? 0) + 1;
    indentLevelCounts[level] = count;

    final s = _formatIndentStyle(
      n,
      indentStyles[level % indentStyles.length],
    );
    // log('${" " * level}$sameIndentIndex ($index/${this.count})...$n');

    return Container(
      alignment: AlignmentDirectional.topEnd,
      width: width,
      padding: EdgeInsetsDirectional.only(end: padding),
      // child: Text(withDot ? '$blockIndex$s.' : '$blockIndex$s',
      //	style: style),
      child: Text('$s$suffix', style: style),
    );
  }

  String _formatIndentStyle(int n, QuillIndentStyle style) {
    switch (style) {
      case QuillIndentStyle.number:
        return '$n';
      case QuillIndentStyle.letter:
        return _toExcelSheetColumnTitle(n);
      case QuillIndentStyle.roman:
        return _intToRoman(n);
    }
  }

  String _toExcelSheetColumnTitle(int n) {
    final result = StringBuffer();
    while (n > 0) {
      n--;
      result.write(String.fromCharCode((n % 26).floor() + 97));
      n = (n / 26).floor();
    }

    return result.toString().split('').reversed.join();
  }

  String _intToRoman(int input) {
    var num = input;

    if (num < 0) {
      return '';
    } else if (num == 0) {
      return 'nulla';
    }

    final builder = StringBuffer();
    for (var a = 0; a < arabianRomanNumbers.length; a++) {
      final times = (num / arabianRomanNumbers[a])
          .truncate(); // equals 1 only when arabianRomanNumbers[a] = num
      // executes n times where n is the number of times you have to add
      // the current roman number value to reach current num.
      builder.write(romanNumbers[a] * times);
      num -= times *
          arabianRomanNumbers[
              a]; // subtract previous roman number value from num
    }

    return builder.toString().toLowerCase();
  }
}




// [log] 0 (1/1)...1
// [log]  0 (1/1)...1
// [log]   0 (1/1)...1
// [log]    0 (1/1)...1
// [log] 1 (1/2)...1
// [log] 1 (2/2)...2
// [log]  0 (1/1)...1
// [log]   0 (1/1)...1
// [log]    0 (1/1)...1
// [log] 3 (1/2)...3
// [log] 3 (2/2)...4
// [log]  0 (1/2)...0
// [log]  0 (2/2)...1
// [log]   0 (1/1)...1
// [log]    0 (1/3)...-1
// [log]    0 (2/3)...0
// [log]    0 (3/3)...1
// [log] 5 (1/1)...6

