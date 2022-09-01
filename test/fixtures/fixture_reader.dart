import 'dart:io';

import 'package:image_picker/image_picker.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

XFile readFile(String name) => XFile('test/fixtures/$name');
