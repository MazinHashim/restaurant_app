class TableSeats {
  int? _id;
  String? _tableType;
  int? _quantity;
  int? _maxSeats;

  TableSeats(int? id, String? tableType, int? quantity, int? maxSeats) {
    if (id != null) {
      _id = id;
    }
    if (tableType != null) {
      _tableType = tableType;
    }
    if (quantity != null) {
      _quantity = quantity;
    }
    if (maxSeats != null) {
      _maxSeats = maxSeats;
    }
  }

  int? get id => _id!;
  set id(int? id) => _id = id;

  String? get tableType => _tableType!;
  set tableType(String? tableType) => _tableType = tableType;

  int? get maxSeats => _maxSeats!;
  set maxSeats(int? maxSeats) => _maxSeats = maxSeats;

  int? get quantity => _quantity!;
  set quantity(int? quantity) => _quantity = quantity;
}
