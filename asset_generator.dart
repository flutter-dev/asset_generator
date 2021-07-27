// Copyright 2018 DebuggerX <dx8917312@gmail.com>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

var preview_server_port = 2227;

bool isHiddenFile(FileSystemEntity file) => file.path[file.parent.path.length + 1] == '.';

void main() async {
  bool working = false;
  var pubSpec = File('pubspec.yaml');
  var pubLines = pubSpec.readAsLinesSync();
  var newLines = <String>[];
  var varNames = <String>[];
  var resource = <String>[];
  for (var line in pubLines) {
    if (line.contains('begin') && line.contains('#') && line.contains('assets')) {
      working = true;
      newLines.add(line);
    }
    if (line.contains('end') && line.contains('#') && line.contains('assets')) working = false;

    if (working) {
      if (line.trim().startsWith('#') && line.trim().endsWith('*')) {
        newLines.add(line);
        var directory = Directory(line.replaceAll('#', '').replaceAll('*', '').trim());
        if (directory.existsSync()) {
          var list = directory.listSync(recursive: true)
            ..sort((a, b) => a.path.compareTo(b.path));
          for (var file in list) {
            if (file.statSync().type == FileSystemEntityType.file && !isHiddenFile(file)) {
              var path = file.path.replaceAll('\\', '/');
              var varName = path.replaceAll('/', '_').replaceAll('.', '_').toLowerCase();
              var pos = 0;
              String char;
              while (true) {
                pos = varName.indexOf('_', pos);
                if (pos == -1) break;
                char = varName.substring(pos + 1, pos + 2);
                varName = varName.replaceFirst('_$char', '_${char.toUpperCase()}');
                pos++;
              }
              varName = varName.replaceAll('_', '');
              resource.add("/// ![](http://127.0.0.1:$preview_server_port/$path)");
              resource.add("static final String $varName = '$path';");
              varNames.add("    $varName,");
              newLines.add('    - $path');
            }
          }
        } else {
          throw FileSystemException('Directory wrong');
        }
      }
    } else {
      newLines.add(line);
    }
  }

  var r = File('lib/r.dart');
  if (r.existsSync()) {
    r.deleteSync();
  }
  r.createSync();
  var content = 'class R {\n';
  for (var line in resource) {
    content = '$content  $line\n';
  }
  content = '$content\n  static final values = [\n';
  for (var line in varNames) {
    content = '$content  $line\n';
  }
  content = '$content  ];\n}\n';
  r.writeAsStringSync(content);

  var spec = '';
  for (var line in newLines) {
    spec = '$spec$line\n';
  }
  pubSpec.writeAsStringSync(spec);

  var ser;
  try {
    ser = await HttpServer.bind('127.0.0.1', preview_server_port);
    print('成功启动图片预览服务器于本机<$preview_server_port>端口');
    ser.listen(
          (req) {
        var index = req.uri.path.lastIndexOf('.');
        var subType = req.uri.path.substring(index + 1);
        print(subType);
        req.response
          ..headers.contentType = ContentType('image', subType)
          ..add(File('.${req.uri.path}').readAsBytesSync())
          ..close();
      },
    );
  } catch (e) {
    print('图片预览服务器已启动或端口被占用');
  }
}
