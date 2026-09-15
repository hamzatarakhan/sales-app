import 'package:flutter/material.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  bool signedIn = false;
  ThemeMode themeMode = ThemeMode.light;
  String language = 'en';
  bool visitReminders = true;

  final userName = 'Hamza Tarakhan';
  final userUsername = 'hamza';
  final userEmail = 'hamza@acme-dist.example';
  final userPhone = '+962 79 000 0000';
  final userCompany = 'Acme Distribution';
  final userVehicle = 'Van #12';

  late List<Product> products;
  late List<Visit> visits;
  late List<SalesOrder> orders;
  late List<Invoice> invoices;

  AppState() {
    _seed();
  }

  void _seed() {
    products = [
      Product(sku: 'BEV-COLA-24', name: 'Cola 330ml Can (24pk)', price: 22.00, vanStock: 40),
      Product(sku: 'BEV-H2O-6', name: 'Spring Water 1.5L (6pk)', price: 19.50, vanStock: 8),
      Product(sku: 'BEV-NRG-12', name: 'Energy Drink 250ml (12pk)', price: 32.00, vanStock: 25),
      Product(sku: 'BEV-OJ-8', name: 'Orange Juice 1L (8pk)', price: 28.00, vanStock: 3),
      Product(sku: 'BEV-LEM-24', name: 'Sparkling Lemonade 330ml (24pk)', price: 30.00, vanStock: 30),
      Product(sku: 'BEV-ICT-12', name: 'Iced Tea Peach 500ml (12pk)', price: 26.00, vanStock: 0),
      Product(sku: 'BEV-DCOLA-24', name: 'Diet Cola 330ml Can (24pk)', price: 22.00, vanStock: 18),
    ];

    visits = [
      Visit(
        id: 'v1',
        customerName: 'الوردة الحمراء',
        address: '12 Rainbow St, Jabal Amman',
        city: 'Amman',
        scheduledTime: '09:00',
        phone: '+962 79 111 2222',
        balance: 120,
        creditLimit: 500,
      ),
      Visit(
        id: 'v2',
        customerName: 'Sunrise Supermarket',
        address: '4 Souq Jara St, Amman',
        city: 'Amman',
        scheduledTime: '12:00',
        phone: '+962 79 333 4444',
        balance: 60,
        creditLimit: 300,
        status: VisitStatus.done,
        checkedIn: true,
        hadPurchase: true,
      ),
    ];

    final cola = products[0], water = products[1], energy = products[2], lemonade = products[4];

    orders = [
      SalesOrder(
        id: 'SO/2026/0501',
        customerName: 'Sunrise Supermarket',
        date: DateTime(2026, 9, 13),
        lines: [OrderLine(product: cola, qty: 10), OrderLine(product: energy, qty: 3)],
        status: OrderStatus.invoiced,
      ),
      SalesOrder(
        id: 'SO/2026/0502',
        customerName: 'Corner Shop 24/7',
        date: DateTime(2026, 8, 20),
        lines: [OrderLine(product: energy, qty: 3)],
        status: OrderStatus.invoiced,
      ),
      SalesOrder(
        id: 'SO/2026/0503',
        customerName: 'الوردة الحمراء',
        date: DateTime(2026, 8, 10),
        lines: [OrderLine(product: lemonade, qty: 16)],
        status: OrderStatus.invoiced,
      ),
      SalesOrder(
        id: 'SO/2026/0504',
        customerName: 'Downtown Mini Market',
        date: DateTime(2026, 9, 10),
        lines: [OrderLine(product: lemonade, qty: 5)],
        status: OrderStatus.draft,
      ),
      SalesOrder(
        id: 'SO/2026/0505',
        customerName: 'Sunrise Supermarket',
        date: DateTime(2026, 9, 11),
        lines: [OrderLine(product: energy, qty: 6)],
        status: OrderStatus.draft,
      ),
    ];

    invoices = [
      Invoice(
        id: 'INV/2026/0231',
        customerName: 'Sunrise Supermarket',
        invoiceDate: DateTime(2026, 8, 28),
        dueDate: DateTime(2026, 9, 28),
        lines: [OrderLine(product: cola, qty: 10), OrderLine(product: energy, qty: 3)],
      ),
      Invoice(
        id: 'INV/2026/0219',
        customerName: 'Corner Shop 24/7',
        invoiceDate: DateTime(2026, 8, 4),
        dueDate: DateTime(2026, 9, 4),
        lines: [OrderLine(product: energy, qty: 3)],
      ),
      Invoice(
        id: 'INV/2026/0244',
        customerName: 'الوردة الحمراء',
        invoiceDate: DateTime(2026, 8, 23),
        dueDate: DateTime(2026, 9, 23),
        lines: [OrderLine(product: water, qty: 10), OrderLine(product: energy, qty: 1)],
      ),
    ];
  }

  int _orderSeq = 1008;
  int _invoiceSeq = 806;

  void signIn() {
    signedIn = true;
    notifyListeners();
  }

  void signOut() {
    signedIn = false;
    notifyListeners();
  }

  void setThemeMode(ThemeMode m) {
    themeMode = m;
    notifyListeners();
  }

  void setLanguage(String l) {
    language = l;
    notifyListeners();
  }

  void setVisitReminders(bool v) {
    visitReminders = v;
    notifyListeners();
  }

  void checkIn(Visit v, int distanceM, {bool photo = false}) {
    v.checkedIn = true;
    v.checkInDistanceM = distanceM;
    v.hasMerchPhoto = photo;
    notifyListeners();
  }

  void markNoPurchase(Visit v) {
    v.status = VisitStatus.done;
    notifyListeners();
  }

  /// Confirms a new order for [visit]: deducts van stock, creates a draft
  /// order, then (once signed) invoices it.
  SalesOrder confirmOrder(Visit visit, List<OrderLine> lines) {
    _orderSeq++;
    final order = SalesOrder(
      id: 'SO/2026/$_orderSeq',
      customerName: visit.customerName,
      date: DateTime.now(),
      lines: lines,
    );
    for (final l in lines) {
      l.product.vanStock -= l.qty;
    }
    orders.insert(0, order);
    visit.status = VisitStatus.done;
    visit.hadPurchase = true;
    notifyListeners();
    return order;
  }

  Invoice signAndInvoice(SalesOrder order) {
    order.hasSignature = true;
    order.status = OrderStatus.invoiced;
    _invoiceSeq++;
    final invoice = Invoice(
      id: 'INV/2026/$_invoiceSeq',
      customerName: order.customerName,
      invoiceDate: DateTime.now(),
      dueDate: DateTime.now(),
      lines: order.lines,
    );
    order.invoiceId = invoice.id;
    invoices.insert(0, invoice);
    notifyListeners();
    return invoice;
  }

  void recordPayment(Invoice invoice, double amount) {
    final remaining = invoice.due - amount;
    invoice.amountDue = remaining < 0 ? 0 : remaining;
    if (invoice.amountDue <= 0) invoice.status = InvoiceStatus.paid;
    notifyListeners();
  }

  int get ordersConfirmedToday =>
      orders.where((o) => _isToday(o.date)).length;
  double get totalSalesToday =>
      orders.where((o) => _isToday(o.date)).fold(0.0, (s, o) => s + o.total);
  int get visitsDoneToday => visits.where((v) => v.status == VisitStatus.done).length;
  int get visitsWithOrderToday => visits.where((v) => v.hadPurchase).length;
  int get visitsNoPurchaseToday =>
      visits.where((v) => v.status == VisitStatus.done && !v.hadPurchase).length;

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

