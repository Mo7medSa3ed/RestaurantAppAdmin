import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deliveryapp/API.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/models/copoun.dart';
import 'package:deliveryapp/provider/appdata.dart';
import 'package:deliveryapp/provider/special.dart';

class AllCopounsTable extends StatefulWidget {
  @override
  _AllCopounsTableState createState() => _AllCopounsTableState();
}

class _AllCopounsTableState extends State<AllCopounsTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var uds;
  var _controller = TextEditingController();
  Specials s;
  List<Copoun> copounList = [];

  void _sort<T>(
    Comparable<T> Function(Copoun d) getField,
    int columnIndex,
    bool ascending,
  ) {
    uds._sort<T>(getField, ascending);
    setState(() {
      if (columnIndex == null) {
        _sortColumnIndex = -1;
      } else {
        _sortColumnIndex = columnIndex;
      }
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<AppData>(
        builder: (ctx, app, c) {
          copounList = app.copounList;
          uds = UDS(
              context: context,
              copounList: copounList,
              filtercopounList: copounList);
          return Container(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 8),
            child: PaginatedDataTable(
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage = value;
                });
              },
              header: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: greyw, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: buildTextField(),
                ),
              ),
              sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
              sortAscending: _sortAscending,
              showCheckboxColumn: false,
              source: uds,
              columns: [
                DataColumn(
                  label: Text('Copoun Name'),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.text, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Duration'),
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.duration, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('amount'),
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.amount, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('Date'),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.updatedAt, columnIndex, ascending),
                ),
                DataColumn(
                  label: Expanded(child: Center(child: Text('Delete'))),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField() {
    s = Provider.of<Specials>(context, listen: false);
    return Selector<Specials, bool>(
        selector: (_, m) => m.istextempty,
        builder: (_, data, c) {
          return TextField(
            controller: _controller,
            onChanged: (v) {
              if (v.toString().trim() == "") {
                uds.filter("-1");
                s.changeIsEmpty(true);
                _controller.clear();
              } else {
                uds.filter(v.trim());
                s.changeIsEmpty(false);
              }
            },
            cursorColor: Kprimary,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _controller.text.toString().trim() == ""
                    ? Icon(Icons.search)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          uds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: 'Search with Copoun name....',
                border: InputBorder.none),
          );
        });
  }
}

class UDS extends DataTableSource {
  List<Copoun> copounList;
  List<Copoun> filtercopounList;
  BuildContext context;
  int _selectedCount = 0;
  UDS({this.copounList, this.context, this.filtercopounList});

  @override
  DataRow getRow(int index) {
    final copoun = copounList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(copoun.text)),
        DataCell(Center(child: Text(copoun.duration.toString()))),
        DataCell(Center(child: Text(copoun.amount.toString()))),
        DataCell(Text(
            copoun.updatedAt == null ? '' : copoun.updatedAt.substring(0, 10))),
        DataCell(Center(
            child: IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () => delete(copoun))))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => copounList.length;

  @override
  int get selectedRowCount => _selectedCount;

  filter(value) {
    if (value == "-1") {
      copounList = filtercopounList;
      notifyListeners();
      return false;
    }
    final l =
        copounList.where((element) => element.text.contains(value)).toList();
    copounList = l;
    notifyListeners();
    return true;
  }

  delete(Copoun c) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: 'Delete Copoun',
      text: "Are you sure ?",
      barrierDismissible: false,
      confirmBtnColor: red,
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          text: "loading please wait....",
          barrierDismissible: false,
        );
        final res = await API.deleteCopoun(c.id);
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          copounList.remove(c);
          appData.notifyListeners();
          notifyListeners();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.slideInUp,
              title: 'Delete Copoun',
              text: "Copoun Deleted Successfully",
              barrierDismissible: false,
              confirmBtnColor: Kprimary,
              onConfirmBtnTap: () => Navigator.of(context).pop());
        } else {
          Navigator.of(context).pop();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.loading,
              title: 'Error',
              text: "some thing went error !!",
              barrierDismissible: false,
              showCancelBtn: true);
        }
      },
    );
  }
}
