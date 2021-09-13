import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:deliveryapp/constants.dart';
import 'package:deliveryapp/models/categorys.dart';
import 'package:deliveryapp/models/copoun.dart';
import 'package:deliveryapp/models/dish.dart';
import 'package:deliveryapp/models/review.dart';
import 'dart:convert';
import 'package:deliveryapp/models/user.dart';

class API {
  static const String _BaseUrl = 'https://resturant-app12.herokuapp.com';

  // Functions For User

  static Future<http.Response> loginUser(User user) async {
    final res = await http.post('$_BaseUrl/users/auth/login',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(user.toJsonForLogin()));
    saveToken(res.headers['x-auth-token']);
    return res;
  }

  static Future<http.Response> signupUser(User user) async {
    final res = await http.post('$_BaseUrl/users/',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(user.toJsonForSignup()));
    // saveToken(res.headers['x-auth-token']);
    return res;
  }

  static updateImage(File image, String id) async {
    String name = image.path.split('/').last;
    FormData form = FormData.fromMap(
        {'avatar': await MultipartFile.fromFile(image.path, filename: name)});
    Dio dio = new Dio();
    dio.options.headers["x-auth-token"] = await getToken();
    dio.options.headers["x-app-type"] = 'Admin';

    await dio.post('$_BaseUrl/users/change/avatar/$id', data: form);
  }

  static Future<http.Response> updateUser(user, id) async {
    final res = await http.patch('$_BaseUrl/users/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(user));
    return res;
  }

  static Future<User> getOneUser(String id) async {
    final response = await http.get(
      '$_BaseUrl/users/$id',
      headers: await getHeaders(),
    );
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body);
    return parsed != null ? User.fromJson(parsed) : null;
  }

  static Future<dynamic> getHome() async {
    final response = await http.get(
      '$_BaseUrl/stats/admin/home',
      headers: await getHeaders(),
    );
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body);

    return parsed != null ? parsed : null;
  }

  static Future<dynamic> getAllUser() async {
    final res = await http.get(
      '$_BaseUrl/users/',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body).cast<Map<String, dynamic>>();
      final userList =
          parsed.map<User>((dish) => User.fromJson2(dish)).toList();
      return {"status": true, "data": userList};
    } else {
      return {"status": false, "data": null};
    }
  }

  // Function For Dish

  static Future<dynamic> getAllDishes() async {
    final res = await http.get(
      '$_BaseUrl/dishes/',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body).cast<Map<String, dynamic>>();
      final dishList = parsed.map<Dish>((dish) => Dish.fromJson(dish)).toList();
      return {"status": true, "data": dishList};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<Dish> getOneDish(String id) async {
    final res = await http.get(
      '$_BaseUrl/dishes/$id',
      headers: await getHeaders(),
    );
    final body = utf8.decode(res.bodyBytes);
    final parsed = json.decode(body);
    return Dish.fromOneJson(parsed);
  }

  static Future<http.Response> deleteDish(String dishId) async {
    final res = await http.delete(
      '$_BaseUrl/dishes/$dishId',
      headers: await getHeaders(),
    );
    return res;
  }

  static updateImageForDish(PickedFile image, String id) async {
    String name = image.path.split('/').last;
    FormData form = FormData.fromMap(
        {'img': await MultipartFile.fromFile(image.path, filename: name)});
    Dio dio = new Dio();
    dio.options.headers["x-auth-token"] = await getToken();
    dio.options.headers["x-app-type"] = 'Admin';

    await dio.patch('$_BaseUrl/dishes/change-img/$id', data: form);
  }

  static Future<http.Response> updateDish(
      String id, Map<String, dynamic> updatedDish) async {
    final res = await http.patch('$_BaseUrl/dishes/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(updatedDish));
    return res;
  }

  // Function For reviews
  static Future<http.Response> addReview(Review review, String id) async {
    final res = await http.post('$_BaseUrl/dishes/reviews/add/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(review.toJson()));

    return res;
  }

  static Future<http.Response> deleteReview(
      String dishId, String reviewid) async {
    final res = await http.delete(
      '$_BaseUrl/reviews?dishId=$dishId&reviewId=$reviewid',
      headers: await getHeaders(),
    );
    return res;
  }

  static Future<http.Response> updateReview(
      Review review, String dishId, String reviewid) async {
    final res = await http.patch(
        '$_BaseUrl/reviews/1?dishId=$dishId&reviewId=$reviewid',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(review.toJson()));
    return res;
  }

  // function For favourite

  static Future<http.Response> addanddelteFav(
      String userid, String dishid) async {
    final res = await http.post('$_BaseUrl/users/fav/$userid',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode({"dishId": dishid}));
    return res;
  }

  // function for orders

  static Future<http.Response> makeOrder(Map<String, dynamic> order) async {
    final res = await http.post('$_BaseUrl/orders/',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(order));

    return res;
  }

  // function for categories
  static Future<dynamic> getAllCategories() async {
    final res = await http.get(
      '$_BaseUrl/categories',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body).cast<Map<String, dynamic>>();
      final categoryList =
          parsed.map<Categorys>((dish) => Categorys.fromJson(dish)).toList();
      return {"status": true, "data": categoryList};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getAllCopouns() async {
    final res = await http.get(
      '$_BaseUrl/coupons',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body).cast<Map<String, dynamic>>();
      final copounList =
          parsed.map<Copoun>((dish) => Copoun.fromJson(dish)).toList();
      return {"status": true, "data": copounList};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<http.Response> deleteCategory(String name) async {
    final res = await http.delete(
      '$_BaseUrl/categories/$name',
      headers: await getHeaders(),
    );
    return res;
  }

  static Future<http.Response> deleteCopoun(String id) async {
    final res = await http.delete(
      '$_BaseUrl/coupons/$id',
      headers: await getHeaders(),
    );
    return res;
  }

  static Future<http.Response> addCategory(
      Map<String, dynamic> categories) async {
    final res = await http.post('$_BaseUrl/categories/',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(categories));

    return res;
  }

  static Future<http.Response> addCopoun(Map<String, dynamic> copoun) async {
    final res = await http.post('$_BaseUrl/coupons/',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(copoun));

    return res;
  }

  static Future<http.Response> updateCategory(
      Map<String, dynamic> categories, id) async {
    final res = await http.patch('$_BaseUrl/categories/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(categories));

    return res;
  }

  static Future<http.Response> patchOrder(
      Map<String, dynamic> order, id) async {
    final res = await http.patch('$_BaseUrl/orders/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: await getHeaders(),
        body: json.encode(order));

    return res;
  }

  static Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyBMD6TqYt-Y0dc4grEFzBmCkHOqsKncgAo";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values.toString(); //;
  }

  static Future<dynamic> getAllOrders({page, state}) async {
    final res = await http.get(
      '$_BaseUrl/orders/state/${state.toString().toLowerCase()}',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {"status": true, "data": parsed};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getOneOrder(id) async {
    final res = await http.get(
      '$_BaseUrl/orders/$id',
      headers: await getHeaders(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);

      return {"status": true, "data": parsed};
    } else {
      return {"status": false, "data": null};
    }
  }
}
