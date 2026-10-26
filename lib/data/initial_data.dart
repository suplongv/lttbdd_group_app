import 'package:flutter/material.dart';
import '../models/models.dart';

final List<ExpenseCategory> initialCategories = [
  ExpenseCategory(id: 'food', name: 'Ăn uống', iconName: 'restaurant', color: const Color(0xFFE27D60), description: 'Cơm trưa, ăn sáng, cafe, thực phẩm'),
  ExpenseCategory(id: 'transport', name: 'Đi lại', iconName: 'directions_car', color: const Color(0xFF41B3A3), description: 'Xăng xe, gửi xe, Grab, bảo dưỡng'),
  ExpenseCategory(id: 'home', name: 'Nhà cửa & Hóa đơn', iconName: 'home', color: const Color(0xFFE8A87C), description: 'Tiền thuê trọ, điện nước, internet'),
  ExpenseCategory(id: 'shopping', name: 'Mua sắm', iconName: 'shopping_bag', color: const Color(0xFF85DCBA), description: 'Quần áo, đồ dùng cá nhân, siêu thị'),
  ExpenseCategory(id: 'health', name: 'Y tế & Sức khỏe', iconName: 'local_hospital', color: const Color(0xFFC38D9E), description: 'Thuốc men, khám bệnh, vitamin'),
  ExpenseCategory(id: 'education', name: 'Học tập & Phát triển', iconName: 'school', color: const Color(0xFF5885AF), description: 'Sách vở, khóa học trực tuyến'),
  ExpenseCategory(id: 'incident', name: 'Phát sinh & Hiếu hỷ', iconName: 'card_giftcard', color: const Color(0xFFD97706), description: 'Đám cưới, sinh nhật, sửa chữa'),
  ExpenseCategory(id: 'savings', name: 'Tiết kiệm & Dự phòng', iconName: 'savings', color: const Color(0xFF223B20), description: 'Tích lũy quỹ khẩn cấp, tiết kiệm mục tiêu'),
  ExpenseCategory(id: 'other', name: 'Chi tiêu khác', iconName: 'more_horiz', color: const Color(0xFF6B7280), description: 'Khoản chi ngoài danh mục'),
];

final List<PresetItem> initialPresetItems = [
  
  PresetItem(id: 'p1', categoryId: 'food', name: 'Ăn sáng (Phở / Bún bò / Bánh mì)', price: 35000, marketPrice: 35000, unit: 'phần'),
  PresetItem(id: 'p2', categoryId: 'food', name: 'Cà phê sáng / Trà đá', price: 25000, marketPrice: 25000, unit: 'ly'),
  PresetItem(id: 'p3', categoryId: 'food', name: 'Cơm trưa văn phòng', price: 45000, marketPrice: 45000, unit: 'phần'),
  PresetItem(id: 'p4', categoryId: 'food', name: 'Cơm tối gia đình / Đi ăn ngoài', price: 60000, marketPrice: 60000, unit: 'người'),
  PresetItem(id: 'p5', categoryId: 'food', name: 'Đi chợ / Siêu thị rau thịt tươi', price: 150000, marketPrice: 150000, unit: 'ngày'),
  PresetItem(id: 'p6', categoryId: 'food', name: 'Trà sữa / Nước ép giải khát', price: 38000, marketPrice: 38000, unit: 'ly'),
  

  PresetItem(id: 'p10', categoryId: 'transport', name: 'Đổ xăng xe máy (Đầy bình)', price: 70000, marketPrice: 70000, unit: 'lần'),
  PresetItem(id: 'p11', categoryId: 'transport', name: 'Vé gửi xe (Ngày / Tháng)', price: 5000, marketPrice: 5000, unit: 'lượt'),
  PresetItem(id: 'p12', categoryId: 'transport', name: 'Đặt xe công nghệ (Grab / Be / Xanh SM)', price: 45000, marketPrice: 45000, unit: 'chuyến'),
  PresetItem(id: 'p13', categoryId: 'transport', name: 'Thay dầu nhớt & Bảo dưỡng xe', price: 120000, marketPrice: 120000, unit: 'lần'),
  PresetItem(id: 'p14', categoryId: 'transport', name: 'Rửa xe máy / Ô tô sạch sẽ', price: 30000, marketPrice: 30000, unit: 'lần'),
  

  PresetItem(id: 'p16', categoryId: 'home', name: 'Tiền thuê trọ / phòng ở', price: 3200000, marketPrice: 3200000, unit: 'tháng'),
  PresetItem(id: 'p17', categoryId: 'home', name: 'Tiền điện & Nước sinh hoạt', price: 450000, marketPrice: 450000, unit: 'tháng'),
  PresetItem(id: 'p18', categoryId: 'home', name: 'Gói cước 4G & Internet cáp quang', price: 220000, marketPrice: 220000, unit: 'tháng'),
  
  PresetItem(id: 'p20', categoryId: 'shopping', name: 'Quần áo & Trang phục cơ bản', price: 250000, marketPrice: 250000, unit: 'món'),
  PresetItem(id: 'p21', categoryId: 'shopping', name: 'Đồ dùng tiêu hao cá nhân', price: 85000, marketPrice: 85000, unit: 'combo'),
  PresetItem(id: 'p22', categoryId: 'shopping', name: 'Mua đồ gia dụng tiện ích', price: 150000, marketPrice: 150000, unit: 'món'),
  

  PresetItem(id: 'p25', categoryId: 'health', name: 'Thuốc cảm cúm & Vitamin C', price: 65000, marketPrice: 65000, unit: 'liều'),
  PresetItem(id: 'p26', categoryId: 'health', name: 'Khám sức khỏe tổng quát / Răng hàm mặt', price: 300000, marketPrice: 300000, unit: 'lần'),
  PresetItem(id: 'p27', categoryId: 'health', name: 'Khẩu trang & Cồn sát khuẩn', price: 35000, marketPrice: 35000, unit: 'hộp'),
  
  PresetItem(id: 'p30', categoryId: 'education', name: 'Sách giáo trình / Kỹ năng sống', price: 110000, marketPrice: 110000, unit: 'cuốn'),
  PresetItem(id: 'p31', categoryId: 'education', name: 'Khóa học trực tuyến (Udemy / Coursera)', price: 350000, marketPrice: 350000, unit: 'khóa'),
  
  PresetItem(id: 'p35', categoryId: 'incident', name: 'Mừng đám cưới / Sinh nhật bạn bè', price: 500000, marketPrice: 500000, unit: 'phong bì'),
  PresetItem(id: 'p36', categoryId: 'incident', name: 'Sửa chữa điện thoại / đồ đạc hỏng', price: 200000, marketPrice: 200000, unit: 'lần'),
  
  PresetItem(id: 'p50', categoryId: 'savings', name: 'Tích lũy quỹ khẩn cấp 500.000₫', price: 500000, marketPrice: 500000, unit: 'lần'),
  PresetItem(id: 'p51', categoryId: 'savings', name: 'Tích lũy quỹ khẩn cấp 1.000.000₫', price: 1000000, marketPrice: 1000000, unit: 'lần'),
  PresetItem(id: 'p52', categoryId: 'savings', name: 'Tiết kiệm mục tiêu du lịch / thiết bị', price: 500000, marketPrice: 500000, unit: 'lần'),
  
  // Chi tiêu khác
  PresetItem(id: 'p40', categoryId: 'other', name: 'Cắt tóc & Gội đầu thư giãn', price: 80000, marketPrice: 80000, unit: 'lần'),
  PresetItem(id: 'p41', categoryId: 'other', name: 'Mua vé số / Cầu may', price: 20000, marketPrice: 20000, unit: 'tờ'),
];

final List<SavingsGoal> initialSavingsGoals = [
  SavingsGoal(
    id: 'sav-1',
    name: 'Quỹ Dự Phòng Khẩn Cấp (3-6 tháng)',
    targetAmount: 30000000,
    currentAmount: 5000000,
    icon: 'shield',
    note: 'Tiền mặt an toàn đề phòng sự cố bất ngờ',
  ),
  SavingsGoal(
    id: 'sav-2',
    name: 'Mua sắm thiết bị & Du lịch',
    targetAmount: 15000000,
    currentAmount: 2500000,
    icon: 'flight',
    note: 'Tích lũy mua sắm',
  ),
];

final List<TransactionItem> initialTransactions = [
  TransactionItem(
    id: 'tx_init_1',
    categoryId: 'income',
    categoryName: 'Thu nhập',
    amount: 18000000,
    type: TransactionType.income,
    date: DateTime.now().subtract(const Duration(days: 4)),
    note: 'Lương chuyển khoản tháng này',
  ),
  TransactionItem(
    id: 'tx_init_2',
    categoryId: 'savings',
    categoryName: 'Tiết kiệm & Dự phòng',
    subcategory: 'Quỹ Dự Phòng Khẩn Cấp (3-6 tháng)',
    amount: 3000000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
    note: 'Trích quỹ dự phòng khẩn cấp',
  ),
  TransactionItem(
    id: 'tx_init_3',
    categoryId: 'home',
    categoryName: 'Nhà cửa & Hóa đơn',
    subcategory: 'Tiền thuê trọ / phòng ở',
    amount: 3200000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(days: 3)),
    note: 'Tiền thuê phòng tháng này',
  ),
  TransactionItem(
    id: 'tx_init_4',
    categoryId: 'savings',
    categoryName: 'Tiết kiệm & Dự phòng',
    subcategory: 'Mua sắm thiết bị & Du lịch',
    amount: 1500000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    note: 'Gửi tiết kiệm mua laptop mới',
  ),
  TransactionItem(
    id: 'tx_init_5',
    categoryId: 'food',
    categoryName: 'Ăn uống',
    subcategory: 'Đi chợ / Siêu thị rau thịt tươi',
    amount: 250000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    note: 'Mua thức ăn cho cả tuần',
  ),
  TransactionItem(
    id: 'tx_init_6',
    categoryId: 'transport',
    categoryName: 'Đi lại',
    subcategory: 'Đổ xăng xe máy (Đầy bình)',
    amount: 70000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(hours: 6)),
    note: 'Đổ xăng đi làm',
  ),
  TransactionItem(
    id: 'tx_init_7',
    categoryId: 'food',
    categoryName: 'Ăn uống',
    subcategory: 'Cơm trưa văn phòng',
    amount: 45000,
    type: TransactionType.expense,
    date: DateTime.now().subtract(const Duration(hours: 2)),
    note: 'Cơm trưa cùng đồng nghiệp',
  ),
];