import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'local_storage.dart';

class NetworkResource {
  final String url, filename;
  final Duration maxAge;

  NetworkResource({this.url, this.filename, this.maxAge});

  Future<String> get({bool forceReload = false}) async {
    if (forceReload || await isCacheExpired()) {
      print('$filename: Fetching from $url');
      return getFromNetwork();
    } else {
      print('Loading cached copy of $filename');
      return getFromCache();
    }
  }

  Future<String> getFromNetwork() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('$url Fetched.');
      print('$url Updating cache...');
      await writeLocalFile(filename, response.body);
      return response.body;
    } else {
      print('$url Fetch failed (${response.statusCode}).');
      var file = await cacheFile();
      if (await file.exists()) {
        print('$url Using a cached copy.');
        return readLocalFile(filename);
      }
      return null;
    }
  }

  Future<String> getFromCache() async {
    return readLocalFile(filename);
  }

  Future<File> cacheFile() async {
    return localFile(filename);
  }

  Future<bool> isCacheExpired() async {
    var file = await cacheFile();
    return (await file.exists())
        ? DateTime.now().difference(await file.lastModified()) > maxAge
        : true;
  }
}
