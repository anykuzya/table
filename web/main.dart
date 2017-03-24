// Copyright (c) 2017, anna. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:collection';
import 'Table.dart';



void main() {
  TableInfo table = new TableInfo();
  generateTables(table);
}

void generateTables(TableInfo tableInfo) {
  TableElement table = querySelector("#table");
  TableSectionElement head = table.createTHead();
  TableRowElement header =  head.insertRow(-1);
  for (int i = 64; i < 91; i++) {
    Element headerElement = new Element.tag('th');
    String txt = i == 64? " ": new String.fromCharCode(i);
    headerElement.text = txt;
    headerElement.id = txt;
    header.insertAdjacentElement('beforeend', headerElement);
  }
  TableSectionElement body = table.createTBody();
  for (int j = 1; j < 21; j++) {
    TableRowElement row =  body.insertRow(-1);

    Element headerElement = new Element.tag('th');
    String rId = j.toString();
    headerElement.text = rId;
    headerElement.id = rId;
    row.insertAdjacentElement('beforeend', headerElement);

    for (int i = 65; i < 91; i++) {
      TableCellElement cell = row.addCell();
      String cId = new String.fromCharCode(i);
      cell.contentEditable = 'True';
      cell.id = cId + rId;
      CellData myCell = new CellData(cell.id);
      tableInfo.cells[cell.id] = myCell;
      cell.onClick.listen((Event e) {
        String id = e.target.id;
        tableInfo.formula(id);
      });
      cell.onKeyDown.listen((KeyboardEvent e) {
        if (e.code == "Enter") {
          e.preventDefault();
          String id = e.target.id;
          tableInfo.calculate(id);
        }
      });

    }
  }
}
