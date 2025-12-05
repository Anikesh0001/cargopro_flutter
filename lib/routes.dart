import 'package:get/get.dart';
import 'views/login_view.dart';
import 'views/otp_view.dart';
import 'views/list_view.dart';
import 'views/detail_view.dart';
import 'views/create_edit_view.dart';

class Routes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String list = '/list';
  static const String detail = '/detail';
  static const String create = '/create';
  static const String edit = '/edit';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => LoginView()),
    GetPage(name: Routes.otp, page: () => OtpView()),
    GetPage(name: Routes.list, page: () => ListViewPage()),
    GetPage(name: Routes.detail, page: () => DetailView()),
    GetPage(name: Routes.create, page: () => CreateEditView()),
    GetPage(name: Routes.edit, page: () => CreateEditView(editMode: true)),
  ];
}
