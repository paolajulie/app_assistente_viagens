import 'package:flutter/material.dart';

class MarkdownFormatter {
  static List<TextSpan> formatText(String text) {
    final List<TextSpan> spans = [];

    final String textWithoutHeaders = _processHeaders(text);

    _processRichText(textWithoutHeaders, spans);

    return spans;
  }

  static String _processHeaders(String text) {
    String processed = text;

    final headerRegex = RegExp(r'#{1,6}\s+(.*?)(?:\n|$)');
    processed = processed.replaceAllMapped(headerRegex, (match) {
      return '${match.group(1)}\n';
    });

    return processed;
  }

  static void _processRichText(String text, List<TextSpan> spans) {
    int currentPosition = 0;

    final RegExp markdownRegex = RegExp(
      r'(\*\*(.+?)\*\*)|(\*(.+?)\*)|(`(.+?)`)|(__(.+?)__)|(_(.+?)_)',
      multiLine: true,
    );

    final matches = markdownRegex.allMatches(text);

    for (final match in matches) {
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, match.start),
        ));
      }

      String matchedText = '';
      TextStyle style = const TextStyle();

      if (match.group(1) != null) {
        matchedText = match.group(2)!;
        style = const TextStyle(fontWeight: FontWeight.bold);
      } else if (match.group(3) != null) {
        matchedText = match.group(4)!;
        style = const TextStyle(fontStyle: FontStyle.italic);
      } else if (match.group(5) != null) {
        matchedText = match.group(6)!;
        style = const TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Color(0xFFEEEEEE),
        );
      } else if (match.group(7) != null) {
        matchedText = match.group(8)!;
        style = const TextStyle(fontWeight: FontWeight.bold);
      } else if (match.group(9) != null) {
        matchedText = match.group(10)!;
        style = const TextStyle(fontStyle: FontStyle.italic);
      }

      spans.add(TextSpan(
        text: matchedText,
        style: style,
      ));

      currentPosition = match.end;
    }

    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
      ));
    }
  }
}
