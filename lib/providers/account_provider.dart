import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/account.dart';
import 'package:resturant_app/models/address.dart';
import 'package:resturant_app/models/closing_days.dart';
import 'package:resturant_app/models/restaurant.dart';

class AccountProvider extends ChangeNotifier {
  final List<Restaurant> _restaurantList = [
    Restaurant(1, "REX", 123456, "09666584421", "Sushi", "homeUrl", "", 1, 1),
    Restaurant(2, "DORE", 123456, "09648516581", "Fish", "homeUrl", "", 2, 2)
  ];
  final List<Address> _addressesList = [
    Address(1, 1234567, "Minato-ku", "Roppongi 1-1-1", "mori Tower", "3B,4404",
        15.56516, 32.54090333333333),
    Address(2, 5522189, "Kiolo-ku", "Roppongi 1-2-2", "Kiol Tower", "8B,6255",
        15.56516, 31.5409037778)
  ];

  final List<Account> _accountList = [
    Account(
        1,
        true,
        "",
        "",
        "cash",
        1000,
        DateTime.now(),
        DateTime.now().subtract(const Duration(hours: 3)),
        DateTime.now(),
        [],
        [ClDays.Wedesday],
        "My Description",
        2)
  ];

  List<Address> get addressesList {
    return [..._addressesList];
  }

  List<Restaurant> get restaurantList {
    return [..._restaurantList];
  }

  List<Account> get accountList {
    return [..._accountList];
  }

  Restaurant findRestaurantByUserId(int userId) {
    return _restaurantList.firstWhere(
        (restaurant) => restaurant.userId == userId,
        orElse: () => Restaurant.initial());
  }

  Address findAddressById(int addressId) {
    return _addressesList.firstWhere((address) => address.id == addressId,
        orElse: () => Address.initial());
  }

  Account findRestaurantAccountByUserId(int userId) {
    return _accountList.firstWhere((account) => account.userId == userId,
        orElse: () => Account.initial());
  }

  void addRestaurant(Restaurant restaurant) {
    _restaurantList.add(restaurant);
    notifyListeners();
  }

  void addRestaurantAccount(Account account) {
    _accountList.add(account);
    for (var res in _accountList) {
      print(res.userId);
    }
    notifyListeners();
  }

  void updateRestaurant(Restaurant restaurant) {
    Restaurant res =
        _restaurantList.firstWhere((res) => res.id == restaurant.id);
    int ind = _restaurantList.indexOf(res);
    _restaurantList.removeAt(ind);
    _restaurantList.insert(ind, restaurant);
    for (var res in _restaurantList) {
      print(res.pastalCode);
    }
    notifyListeners();
  }

  void updateRestaurantAccount(Account account) {
    Account acc = _accountList.firstWhere((acc) => acc.id == account.id);
    int ind = _accountList.indexOf(acc);
    _accountList.removeAt(ind);
    _accountList.insert(ind, account);
    notifyListeners();
  }

  void toggleReservations(int accountId) {
    Account acc = _accountList.firstWhere((acc) => acc.id == accountId);
    acc.isEnabled = !acc.isEnabled!;
  }
}
