const String tBlack = '\x1B[30m';
const String tBlue = '\x1B[34m';
const String tCyan = '\x1B[36m';
const String tGrey = '\x1B[30;1m';
const String tGreen = '\x1B[32m';
const String tMagenta = '\x1B[35m';
const String tRed = '\x1B[31m';
const String tWhite = '\x1B[37m';
const String tYellow = '\x1B[33m';
const String tRGB = '\x1B[38;2;0;0;0m'; // #0;0;0=R;G;B
const String tIndex = '\x1B[38;5;0m';

const String bBlack='\x1B[40m';
const String bBlue='\x1B[44m';
const String bCyan='\x1B[46m';
const String bGrey='\x1B[40;1m';
const String bGreen='\x1B[42m';
const String bMagenta='\x1B[45m';
const String bRed='\x1B[41m';
const String bWhite='\x1B[47m';
const String bYellow='\x1B[43m';
const String bRGB='\x1B[48;2;0;0;0m';
const String bIndex='\x1B[48;5;0m';
//
const String bgCode = "\x1B[48;2;50;50;50m";
const String reset = '\x1B[0m';

class SimpleMarkdown {
  static int columns = 140;

  static String splitLine(String line) {
    var document = [];
    if (line.length > columns) {
      while (line.length > columns) {
        int i = line.lastIndexOf(RegExp(r'[ ,.?!]'), columns+1);
        if (i > 0) {
          document.add(line.substring(0, i+1).trimRight());
          line = line.substring(i+1).trimLeft();
        } else {
          break;
        }
      }
      document.add(line);
    } else {
      document.add(line);
    }
    return (document.join("\n"));
  }

  static String parse(String response) {
    var document = [];
    var lines = response.split('\n');

    for (var line in lines) {
      if (RegExp(r'^```(.+)').hasMatch(line)) {
        document.add(tMagenta);
      } else if (RegExp(r'^```$').hasMatch(line)) {
        document.add(reset);
      } else {
        int first;
        while ((first = line.indexOf('`')) >= 0) {
          int last = line.indexOf('`', first + 1);
          if (last > 0) {
            line = "${line.substring(0, first)}$tRed$bgCode\u2009${line.substring(first + 1, last)}\u2009$reset${line.substring(last + 1)}";
          }
        }

        document.add(splitLine(line));
      }
    }

    return document.join("\n");
  }
}
