import 'dart:html';
import 'dart:collection';
import 'dart:math';
import 'dart:convert';
import 'Parser.dart';
import 'Token.dart';

class CellData {
  String formula = "";
  String id;
  Element cell;
  List<CellData> containsIn = new List<CellData>();
  List<CellData> dependsOn = new List<CellData>();

  CellData(String id) {
    this.id = id;
    this.cell = querySelector("#" + id);
  }
  void showFormula() {
    this.cell.text = this.formula;
  }
  dynamic toJson() => formula;

  void calc(TableInfo table, bool fromCell) {
    if (fromCell) {
      showFormula();
    }
    this.formula = this.cell.text;
    ParsedFormula parsedFormula = new ParsedFormula(this);
    print('parsed, start calc');
    Element cell = querySelector("#" + id);

    if (parsedFormula.isAtom) {
      this.cell.text = parsedFormula.atom;
    } else {
      Queue<Token> stack_arg = new Queue<Token>();
      clearDependences();
      for (Token token in parsedFormula.parsed) {
        print("token is " + token.token);
        if (token.isRef()) {
          CellData ref = table.cells[token.token];
          this.dependsOn.add(ref);
          ref.containsIn.add(this);
          token = new Token(table.cells[token.token].cell.text);
        }
        if (token.isFunc()) {
          Token arg_token;
          num arg;
          try {
            arg_token = stack_arg.removeFirst();
            print(arg_token.token);
          } catch (e) {
            print("invalid formula func");
            cell.text = "Invalid formula";
          }
          if (token.token == 'SIN') {
            try {
              arg = num.parse(arg_token.token);
              print(arg);
            } catch (e) {
              cell.text = 'Invalid argument in SIN';
            }
            stack_arg.addFirst(new Token(sin(arg).toString()));
          } else if (token.token == 'ABS') {
            try {
              arg = num.parse(arg_token.token);
            } catch (e) {
              cell.text = 'Invalid argument in ABS';
            }
            stack_arg.addFirst(new Token(max(arg, arg * (-1)).toString()));
          } else if (token.token == '--') {
            try {
              arg = num.parse(arg_token.token);
            } catch (e) {
              cell.text = 'Invalid argument after -';
            }
            stack_arg.addFirst(new Token((arg * (-1)).toString()));
          } else if (token.token == '++') {
            try {
              arg = num.parse(arg_token.token);
            } catch (e) {
              cell.text = 'Invalid argument after +';
            }
            stack_arg.addFirst(new Token((arg).toString()));
          } else if (token.token == 'LEN') {
            stack_arg.addFirst(new Token((arg_token.token.length).toString()));
          }
        } else if (token.isBinaryOp()) {
          num arg1;
          num arg2;
          Token arg_token1;
          Token arg_token2;
          try {
            arg_token2 = stack_arg.removeFirst();
            arg_token1 = stack_arg.removeFirst();
          } catch (e) {
            print("invalid formula op");
            cell.text = "Invalid formula";
          }
          if (token.token == '+') {
            try {
              arg2 = num.parse(arg_token2.token);
              arg1 = num.parse(arg_token1.token);
            } catch (e) {
              cell.text = 'Invalid argument around +';
            }
            stack_arg.addFirst(new Token((arg1 + arg2).toString()));
          } else if (token.token == '*') {
            try {
              arg2 = num.parse(arg_token2.token);
              arg1 = num.parse(arg_token1.token);
            } catch (e) {
              cell.text = 'Invalid argument around *';
            }
            stack_arg.addFirst(new Token((arg1 * arg2).toString()));
          } else if (token.token == '-') {
            try {
              arg2 = num.parse(arg_token2.token);
              arg1 = num.parse(arg_token1.token);
            } catch (e) {
              cell.text = 'Invalid argument around -';
            }
            stack_arg.addFirst(new Token((arg1 - arg2).toString()));
          } else if (token.token == '/') {
            try {
              arg2 = num.parse(arg_token2.token);
              arg1 = num.parse(arg_token1.token);
            } catch (e) {
              cell.text = 'Invalid argument around /';
            }
            stack_arg.addFirst(new Token((arg1 / arg2).toString()));
          }
        } else if (token.isDigit() || token.isString()) {
          print(token.token);
          stack_arg.addFirst(token);
          print("added in stack");
        }
      }
      if (stack_arg.length != 1) {
          print("Invalid formula");
          cell.text = "Invalid formula";
      } else {
          cell.text = stack_arg.removeFirst().token;
      }
    }
    notifyAll(table);
    window.getSelection().removeAllRanges();
    table.save();
  }
  void notifyAll(TableInfo table) {
    for (CellData c in containsIn) {
      c.calc(table, true);
    }
  }
  void clearDependences() {
    for (CellData c in dependsOn) {
      c.containsIn.remove(this);
    }
    dependsOn.clear();
  }

}

class TableInfo {
  Map<String, CellData> cells;

  TableInfo() {
    cells = new Map<String, CellData>();
  }
  void calculate(id) {
    cells[id].calc(this, false);
  }
  void formula(id) {
    cells[id].showFormula();
  }
  void save() {
    window.localStorage['table'] = JSON.encode(this.cells);
  }
  void recover(var json) {
    Map data = JSON.decode(json);
    for (String id in data.keys) {
      cells[id] = new CellData(id);
      cells[id].formula = data[id];
    }
    for (String id in cells.keys) {
      cells[id].calc(this, true);
    }
  }
}