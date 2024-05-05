//helper untuk membantu mambaca json untuk kebutuhan testing nantinya

import 'dart:io';

String readJson(String filename) {
  var path = '${Directory.current.path}/test/helper/dummy_data/$filename';
  return File(path).readAsStringSync();
}