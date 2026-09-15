enum VisitStatus { planned, done }

class Visit {
  Visit({
    required this.id,
    required this.customerName,
    required this.address,
    required this.city,
    required this.scheduledTime,
    required this.phone,
    required this.balance,
    required this.creditLimit,
    this.status = VisitStatus.planned,
    this.checkedIn = false,
    this.checkInDistanceM,
    this.hasMerchPhoto = false,
    this.hadPurchase = false,
  });

  final String id;
  final String customerName;
  final String address;
  final String city;
  final String scheduledTime;
  final String phone;
  final double balance;
  final double creditLimit;
  VisitStatus status;
  bool checkedIn;
  int? checkInDistanceM;
  bool hasMerchPhoto;
  bool hadPurchase;
}

class Product {
  Product({
    required this.sku,
    required this.name,
    required this.price,
    required this.vanStock,
  });

  final String sku;
  final String name;
  final double price;
  int vanStock;

  bool get isOut => vanStock <= 0;
  bool get isLow => vanStock > 0 && vanStock < 10;
}

class OrderLine {
  OrderLine({required this.product, required this.qty, this.discountPercent = 0});
  final Product product;
  final int qty;
  final int discountPercent;

  double get unitPrice => product.price * (1 - discountPercent / 100);
  double get total => unitPrice * qty;
}

enum OrderStatus { draft, invoiced }

class SalesOrder {
  SalesOrder({
    required this.id,
    required this.customerName,
    required this.date,
    required this.lines,
    this.status = OrderStatus.draft,
    this.hasSignature = false,
    this.invoiceId,
  });

  final String id;
  final String customerName;
  final DateTime date;
  final List<OrderLine> lines;
  OrderStatus status;
  bool hasSignature;
  String? invoiceId;

  double get total => lines.fold(0, (s, l) => s + l.total);
}

enum InvoiceStatus { notPaid, paid }

class Invoice {
  Invoice({
    required this.id,
    required this.customerName,
    required this.invoiceDate,
    required this.dueDate,
    required this.lines,
    this.status = InvoiceStatus.notPaid,
  });

  final String id;
  final String customerName;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final List<OrderLine> lines;
  InvoiceStatus status;

  double get untaxed => lines.fold(0, (s, l) => s + l.total);
  double get tax => untaxed * 0.16;
  double get total => untaxed + tax;
  double amountDue = -1;
  double get due => amountDue < 0 ? total : amountDue;
}
