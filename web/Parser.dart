import 'Token.dart';
import 'Table.dart';
import 'dart:collection';
import 'dart:html';

class ParsedFormula {
  bool isAtom = false;
  String atom;
  List<Token> parsed = new List<Token>();
  ParsedFormula(CellData cell) {
    String formula = cell.formula;
    (formula);
    if (formula.length == 0 || formula[0] != "=") {
      this.isAtom = true;
      this.atom = formula;
    } else {
      formula = formula.substring(1);
      RegExp regExp = new RegExp(r'ABS|LEN|SIN|\d+\.?\d*|[\(\)\*\+\-/]|"[a-zA-Z]+"|[A-Z]\d\d?');
      Iterable<Match> matches = regExp.allMatches(formula);
      List<Token> tokens = new List<Token>();
      matches.forEach((match) {
        tokens.add(new Token(match.group(0)));
      });

      Queue<Token> stack_op = new Queue<Token>();
      bool next_op_binary = true;
      for (Token token in tokens) {
        if (this.isAtom) {
          ("breaked");
          break;
        }
        if (token.token.trim() == "") {
          continue;
        }
        if (token.isFunc()) {
          stack_op.addFirst(token);
          next_op_binary = true;
        } else if ((token.token == '-' || token.token == '+') && next_op_binary) {
          if (token.token == '-') {
            token.token = token.token + '-';
          }
          if (token.token == '+') {
            token.token = token.token + '+';
          }
          stack_op.addFirst(token);
          next_op_binary = true;
        } else if(token.token == "(") {
          stack_op.addFirst(token);
          next_op_binary = true;
        } else if (token.token == ")") {
          while (stack_op.isNotEmpty && stack_op.first.token != "(") {
              this.parsed.add(stack_op.removeFirst());
          }
          if (stack_op.isEmpty) {
            print("Invalid parenthesis");

            this.isAtom = true;
            this.atom = "Invalid parenthesis";
            break;
          }
          stack_op.removeFirst();
          next_op_binary = false;
        } else if (token.isBinaryOp()) {
          while (stack_op.isNotEmpty && stack_op.first.isBinaryOp() && stack_op.first.opPriority() >= token.opPriority()) {
            this.parsed.add(stack_op.removeFirst());
          }
          stack_op.addFirst(token);
          next_op_binary = true;
        } else if (token.isDigit() || token.isString() || token.isRef()) {
          this.parsed.add(token);
          next_op_binary = false;
        } else {
          print("unexpected token");

          this.isAtom = true;
          this.atom = "Unexpected token " + token.token;
          break;
        }
      }
      while (stack_op.isNotEmpty) {
        if (stack_op.first.token == "(" || stack_op.first.token == ")") {
          print("Invalid parenthesis");

          this.isAtom = true;
          this.atom = "Invalid parenthesis";
          break;
        }
        else {
          this.parsed.add(stack_op.removeFirst());
        }
      }
    }
  }
}
