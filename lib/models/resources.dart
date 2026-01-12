//resources

//for introScreen
import 'package:ecommerce_app_firebase/models/product_model.dart';
import 'package:flutter/material.dart';

int currentPage = 0;
CarouselController carouselController = CarouselController();
dynamic person;
String? currentUserEmail; // Email of logged-in user
String userRole = 'user'; // Role: 'admin' or 'user'

List viewPage = [
  {
    'Title': 'Order Your Food',
    'image': 'assets/images/stocks/1.png',
    'desc': 'Now you can order food any time right from your mobile.',
  },
  {
    'Title': 'Cooking Safe Food',
    'image': 'assets/images/stocks/2.png',
    'desc': 'We are maintain safety and We keep clean while making food.',
  },
  {
    'Title': 'Quick delivery',
    'image': 'assets/images/stocks/3.png',
    'desc': 'Orders your favourite meals will be immediately deliver',
  },
];

//for signInScreen
final GlobalKey<FormState> SignInKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? email;
String? password;
bool viewPassword = true;

//for loginScreen
final GlobalKey<FormState> logInKey = GlobalKey<FormState>();
TextEditingController emailControllerLog = TextEditingController();
TextEditingController passwordControllerLog = TextEditingController();
String? logEmail;
String? logPassword;
bool logViewPassword = true;

//for HomePage and Detail Page
List viewCategory = [
  {
    'id': 1,
    'name': 'All',
  },
  {
    'id': 2,
    'name': 'Cây Ăn Quả',
  },
  {
    'id': 3,
    'name': 'Cây lấy hạt',
  },
];
List category = [
  {
    'id': 1,
    'name': 'Cây Ăn Quả',
    'img': '🍎',
  },
  {
    'id': 2,
    'name': 'Cây lấy hạt',
    'img': '🌰',
  },
];

List AllProducts = [
  products(
    id: 2,
    name: 'Hạt Cà Phê',
    category: 'Cây lấy hạt',
    description: 'description:',
    image: 'assets/images/stocks/caphe.png',
    quantity: 1,
    price: 10000,
  ),
  products(
    id: 1,
    name: 'Hạt Cà Chua',
    category: 'Cây Ăn Quả',
    description: 'description:',
    image: 'assets/images/fiction/cachua.png',
    quantity: 1,
    price: 10000,
  ),
  products(
    id: 2,
    name: 'Cây Ngô',
    category: 'Cây lấy hạt',
    description: 'description:',
    image: 'assets/images/stocks/ngo.png',
    quantity: 1,
    price: 10000,
  ),
  products(
    id: 1,
    name: 'Hạt Táo',
    category: 'Cây Ăn Quả',
    description: 'description:',
    image: 'assets/images/fiction/tao.png',
    quantity: 1,
    price: 10000,
  ),
  products(
    id: 2,
    name: 'Hạt đậu nành',
    category: 'Cây lấy hạt',
    description: 'description:',
    image: 'assets/images/stocks/daunanh.png',
    quantity: 1,
    price: 10000,
  ),
  products(
    id: 1,
    name: 'Hạt Lê',
    category: 'Cây Ăn Quả',
    description: 'description:',
    image: 'assets/images/fiction/le.png',
    quantity: 1,
    price: 10000,
  ),
];
