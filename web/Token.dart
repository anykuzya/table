
class Token {
  String token;

  Token(String s) {
    if (s.length > 0 && s[0] == '"' && s[s.length - 1] == '"') {
      s = s.substring(1, s.length - 1);
    }
    this.token = s;
  }

  bool isDigit() {
    RegExp regExp = new RegExp(r'-?\d+\.?\d*');
//    print("digit? ${regExp.hasMatch(this.token)? 'yes': 'no'}");
    return regExp.hasMatch(this.token);
  }

  bool isRef() {
    RegExp regExp = new RegExp(r'[A-Z]\d\d?');
//    print("ref? ${regExp.hasMatch(this.token)? 'yes': 'no'}");
    return regExp.hasMatch(this.token);
  }

  bool isString() {
    RegExp regExp = new RegExp(r'[a-zA-Z]*');
//    print("string? ${regExp.hasMatch(this.token)? 'yes': 'no'}");
    return regExp.hasMatch(this.token);
  }

  bool isFunc() {
    RegExp regExp = new RegExp(r'ABS|LEN|SIN|--|\+\+');
//    print("func? ${regExp.hasMatch(this.token)? 'yes': 'no'}");
    return regExp.hasMatch(this.token);
  }

  bool isBinaryOp() {
    RegExp regExp = new RegExp(r'[\*\+\-/]');
//    print("op? ${regExp.hasMatch(this.token)? 'yes': 'no'}");
    return regExp.hasMatch(this.token);
  }

  int opPriority() {
    return ((this.token == "+" || this.token == "-") ? 0 : 1);
  }
}