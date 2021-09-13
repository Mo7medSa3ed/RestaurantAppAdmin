import 'package:flutter/foundation.dart';
import 'package:deliveryapp/models/copoun.dart';
import 'package:deliveryapp/models/dish.dart';
import 'package:deliveryapp/models/order.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/models/categorys.dart';

class AppData extends ChangeNotifier {
  User loginUser;
  List<Dish> dishesList = [];
  List<Dish> loadeddishesList = [];
  List<Categorys> categoryList = [];
  List<dynamic> ordersList = [];
  List<User> usersList = [];
  List<Dish> cartList = [];
  List<Copoun> copounList = [];
  String address;
  Order detailsOrder;

  changeOrderState(id) {
    final idx = ordersList.indexWhere((e) => e['_id'] == id);
    if (idx != -1) {
      ordersList[idx]['state'] = 'cancel';
    }
    notifyListeners();
  }

  initOrder(detailsOrder) {
    this.detailsOrder = detailsOrder;
    // notifyListeners();
  }

  initLoginUser(User user) {
    loginUser = user;
    notifyListeners();
  }

  initUserList(user) {
    usersList = user;
  }

  initDishesList(list) {
    dishesList = list;
    // notifyListeners();
  }

  initOrderList(List<dynamic> list) {
    ordersList = list;
    notifyListeners();
  }

  initCategoryList(List<Categorys> list) {
    categoryList = list;
  }

  initCopounList(List<Copoun> list) {
    copounList = list;
  }

  addDish(Dish d) {
    dishesList.add(d);
    notifyListeners();
  }

  addtoCategory(c) {
    categoryList.add(c);
    notifyListeners();
  }

  addtoCopoun(c) {
    copounList.add(c);
    notifyListeners();
  }

  updateCategory(Categorys c) {
    final r = categoryList.indexWhere((e) => e.id == c.id);
    if (r != -1) {
      categoryList[r] = c;
      notifyListeners();
    }
  }

  addUser(User user) {
    usersList.add(user);
    notifyListeners();
  }

  updateDish(Dish d) {
    final r = dishesList.indexWhere((e) => e.id == d.id);
    if (r != -1) {
      dishesList[r] = d;
      notifyListeners();
    }
  }

  updateOrder(dynamic o) {
    final r = ordersList.indexWhere((e) => e['_id'] == o['_id']);
    if (r != -1) {
      ordersList[r] = o;
      notifyListeners();
    }
  }
}
