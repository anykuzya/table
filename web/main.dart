// Copyright (c) 2017, anna. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

void main() {
  generateTables();
}

void generateTables() {
  TableElement table = querySelector("#table");
  TableSectionElement head = table.createTHead();
  TableRowElement header =  head.insertRow(-1);
  for (int i = 64; i < 91; i++) {
    Element headerElement = new Element.tag('th');
    String txt = new String.fromCharCode(i);
    headerElement.text = txt;
    headerElement.id = txt;
    header.insertAdjacentElement('beforeend', headerElement);
  }
  TableSectionElement body = table.createTBody();
  for (int i = 1; i < 21; i++) {
    TableRowElement row =  body.insertRow(-1);

    Element headerElement = new Element.tag('th');
    String txt = i.toString();
    headerElement.text = txt;
    headerElement.id = txt;
    row.insertAdjacentElement('beforeend', headerElement);

    for (int i = 65; i < 91; i++) {
      TableCellElement cell = row.addCell();
      String c = new String.fromCharCode(i);
      String r = i.toString();
      cell.contentEditable = 'True';
      headerElement.id = c+r;
    }
  }
}