class TransactionList {
  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      transactionId: json['transactionId'] as String,
      totalAmount: json['totalAmount'] as int,
      deliveryAddress: json['deliveryAddress'] as String,
      recipientName: json['recipientName'] as String,
      recipientPhone: json['recipientPhone'] as String,
      createdAt: json['createdAt'] as String,
      fulfilledBy: json['fulfilledBy'] as String,
      deliveryStatus: json['deliveryStatus'] as String,
      status: json['status'] as String,
      orders: (json['orders'] as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  TransactionList({
    required this.transactionId,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.recipientName,
    required this.recipientPhone,
    required this.createdAt,
    required this.fulfilledBy,
    required this.deliveryStatus,
    required this.status,
    required this.orders,
  });

  final String transactionId;
  final int totalAmount;
  final String deliveryAddress;
  final String recipientName;
  final String recipientPhone;
  final String createdAt;
  final String fulfilledBy;
  final String deliveryStatus;
  final String status;
  final List<Order> orders;
}

class Order {
  Order({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.transactionId,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.recipientName,
    required this.recipientPhone,
    required this.deliveryStatus,
    required this.status,
    required this.fulfilledBy,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sellerId: json['sellerId'] as String,
      transactionId: json['transactionId'] as String,
      totalAmount: json['totalAmount'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      recipientName: json['recipientName'] as String,
      recipientPhone: json['recipientPhone'] as String,
      deliveryStatus: json['deliveryStatus'] as String,
      status: json['status'] as String,
      fulfilledBy: json['fulfilledBy'] as String,
      createdAt: json['createdAt'] as String,
      items: (json['items'] as List)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String userId;
  final String sellerId;
  final String transactionId;
  final String totalAmount;
  final String deliveryAddress;
  final String recipientName;
  final String recipientPhone;
  final String deliveryStatus;
  final String status;
  final String fulfilledBy;
  final String createdAt;
  final List<Item> items;
}

class Item {
  Item({
    required this.id,
    required this.userId,
    required this.variant,
    required this.quantity,
    required this.productId,
    required this.meta,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      userId: json['userId'] as String,
      variant: json['variant'] as String,
      quantity: json['quantity'] as int,
      productId: json['productId'] as String,
      meta: ItemMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  final String id;
  final String userId;
  final String variant;
  final int quantity;
  final String productId;
  final ItemMeta meta;
}

class ItemMeta {
  ItemMeta({
    required this.name,
    required this.image,
    required this.price,
    required this.sellerId,
  });

  factory ItemMeta.fromJson(Map<String, dynamic> json) {
    return ItemMeta(
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as int,
      sellerId: json['sellerId'] as String,
    );
  }

  final String name;
  final String image;
  final int price;
  final String sellerId;
}
