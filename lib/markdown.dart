import 'package:ansicolor/ansicolor.dart' as ansi;
import 'package:markdown/markdown.dart';

class SimpleMarkdown {
  static final ansi.AnsiPen aStrong = ansi.AnsiPen()..green(bold: true);
  static final ansi.AnsiPen aStrikethrough = ansi.AnsiPen()..red(bold: true);
  static final ansi.AnsiPen aCode = ansi.AnsiPen()..cyan(bold: true);
  static final ansi.AnsiPen aH1 = ansi.AnsiPen()
    ..rgb(r: 0.0, g: 0.0, b: 1.0)
    ..rgb(r: 0.8, g: 0.8, b: 0.8, bg: true);
  static final ansi.AnsiPen aH2 = ansi.AnsiPen()
    ..rgb(r: 0.0, g: 0.0, b: 1.0)
    ..rgb(r: 0.6, g: 0.6, b: 0.6, bg: true);
  static final ansi.AnsiPen aH3 = ansi.AnsiPen()
    ..rgb(r: 0.0, g: 0.0, b: 1.0)
    ..rgb(r: 0.4, g: 0.4, b: 0.4, bg: true);
  static final ansi.AnsiPen aH4 = ansi.AnsiPen()
    ..rgb(r: 0.0, g: 0.0, b: 8.0)
    ..rgb(r: 0.2, g: 0.2, b: 0.2, bg: true);
  static final ansi.AnsiPen aH5 = ansi.AnsiPen()..rgb(r: 0.0, g: 0.0, b: 6.0);
  static final ansi.AnsiPen aH6 = ansi.AnsiPen()..rgb(r: 0.0, g: 0.0, b: 4.0);
  static final ansi.AnsiPen aLink = ansi.AnsiPen()..magenta(bold: true);
  static final ansi.AnsiPen aItalic = ansi.AnsiPen()..yellow(bold: false);

  int columns;

  SimpleMarkdown({this.columns = 140, bool ansiColorDisabled = false}) {
    ansi.ansiColorDisabled = ansiColorDisabled;
  }

  List<String> _splitLine(String line) {
    List<String> document = [];
    if (line.length > columns) {
      while (line.length > columns) {
        int i = line.lastIndexOf(RegExp(r'[ ,.?!]'), columns + 1);
        if (i > 0) {
          document.add(line.substring(0, i + 1).trimRight());
          line = line.substring(i + 1).trimLeft();
        } else {
          break;
        }
      }
      document.add(line);
    } else {
      document.add(line);
    }
    return (document);
  }

  String _printElement(Node node) {
    if (node is Element) {
      return (_parseElement(node));
    }
    return (node.textContent);
  }

  String parseMarkdown(String markdownData) {
    final Document document = Document(extensionSet: ExtensionSet.gitHubFlavored, encodeHtml: false);
    final nodes = document.parse(markdownData);
    final List<String> lines = [];
    for (var e in nodes) {
      lines.add(_printElement(e));
    }
    return (lines.join('\n'));
  }

  String _italic(String text) {
    return ("\x1B[3$text\x1B[0m");
  }

  String _spacer(String textContent) {
    return ('\u2009$textContent\u2009');
  }

  String _parseParagraphe(Element node) {
    String text = "";
    node.children?.forEach((e) {
      if (e is Element) {
        text += _parseElement(e);
      } else if (e is Text) {
        text += e.text;
      } else {
        text += e.textContent;
      }
    });
    return ("$text\n");
  }

  String _parseElement(Element e) {
    switch (e.tag) {
      case "p":
        return (_parseParagraphe(e));
      case "strong":
        return (aStrong(e.textContent));
      case "em":
        return (_italic(e.textContent));
      case "del":
        return (aStrikethrough(e.textContent));
      case "a":
        return ("${aLink(e.textContent)} <${e.attributes['href']}>");
      case "code":
        return (aCode(e.textContent));
      case "h1":
        return (aH1(_spacer(e.textContent)));
      case "h2":
        return (aH2(_spacer(e.textContent)));
      case "h3":
        return (aH3(_spacer(e.textContent)));
      case "h4":
        return (aH4(_spacer(e.textContent)));
      case "h5":
        return (aH5(_spacer(e.textContent)));
      case "h6":
        return (aH6(_spacer(e.textContent)));
      case "pre":
        return (_parsePre(e));
      case "hr":
        return ("${"".padLeft(columns, '_')}\n");
      case "blockquote":
        return (_parseBlockquote(e));
      case "ul":
        return (_parseUl(e));
      case "ol":
        return (_parseOl(e));
      default:
        return (e.textContent);
    }
  }

  String _parsePre(Element e) {
    if (e.children != null) {
      return _parseElement(e.children?.first as Element);
    }
    return (e.textContent);
  }

  String _parseOl(Element node) {
    String ol = "";
    int cnt = 1;

    node.children?.forEach((e) {
      if (e is Element && e.tag == "li") {
        ol += "${cnt++}.${e.textContent}\n";
      } else {
        ol += e.textContent;
      }
    });
    return (ol);
  }

  String _parseUl(Element node) {
    String ul = "";
    node.children?.forEach((e) {
      if (e is Element && e.tag == "li") {
        ul += "-${e.textContent}\n";
      } else {
        ul += e.textContent;
      }
    });
    return (ul);
  }

  String _parseBlockquote(Element e) {
    String quote = "";
    for (var x in e.textContent.split('\n')) {
      for (var l in _splitLine(x)) {
        quote += "| $l\n";
      }
    }
    return (quote);
  }
}
