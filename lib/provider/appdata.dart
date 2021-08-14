import 'package:flutter/foundation.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/models/categorys.dart';

class AppData extends ChangeNotifier {
  User loginUser;
  List<Dish> dishesList = [];
  List<Dish> loadeddishesList = [];
  List<Categorys> categoryList = [];
  List<dynamic> ordersList = [];
  List<User> usersList = [];

  List<Dish> cartList = [];
  String address;

  initLoginUser(User user) {
    loginUser = user;
    notifyListeners();
  }

  initUserList(user) {
    usersList = user;
    notifyListeners();
  }

  initDishesList(List<Dish> list) {
    dishesList = list;
    notifyListeners();
  }

  initOrderList(List<dynamic> list) {
    ordersList = list;
    notifyListeners();
  }

  initCategoryList(List<Categorys> list) {
    categoryList = list;
    notifyListeners();
  }

  addDish(Dish d) {
    dishesList.add(d);
    notifyListeners();
  }

  addtoCategory(c) {
    categoryList.add(c);
    notifyListeners();
  }

  updateCategory(Categorys c) {
    final r = categoryList.indexWhere((e) => e.id == c.id);
    categoryList[r] = c;
    notifyListeners();
  }

  updateDish(Dish d) {
    final r = dishesList.indexWhere((e) => e.id == d.id);
    dishesList[r] = d;
    notifyListeners();
  }

  updateOrder(dynamic o) {
    final r = ordersList.indexWhere((e) => e['_id'] == o['_id']);
    ordersList[r] = o;
    notifyListeners();
  }
}
