import 'package:basic_implementation/services/location_service.dart';
import 'package:get/get.dart';


class Observer extends GetxController {
  var data = (LocationService.langDict.defaultLang as String).obs;
}