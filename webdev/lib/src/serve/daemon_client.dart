// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:build_daemon/client.dart';
import 'package:build_daemon/constants.dart';
import 'package:webdev/src/util.dart';

/// Connects to the `build_runner` daemon.
Future<BuildDaemonClient> connectClient(
        String workingDirectory, List<String> options) =>
    BuildDaemonClient.connect(
        workingDirectory,
        // On Windows we need to call the snapshot directly otherwise
        // the process will start in a disjoint cmd without access to
        // STDIO.
        (Platform.isWindows ? [dartPath, pubSnapshot] : ['pub'])
          ..addAll(['run', 'build_runner', 'daemon'])
          ..addAll(options));

/// Returns the port of the daemon asset server.
int daemonPort(String workingDirectory) {
  var portFile = File(_assetServerPortFilePath(workingDirectory));
  if (!portFile.existsSync())
    throw Exception('Unable to read daemon asset port file.');
  return int.parse(portFile.readAsStringSync());
}

String _assetServerPortFilePath(String workingDirectory) =>
    '${daemonWorkspace(workingDirectory)}/.asset_server_port';
