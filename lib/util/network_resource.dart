import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'local_storage.dart';

class NetworkResource {
  final String url, filename;
  final Duration maxAge;

  NetworkResource({this.url, this.filename, this.maxAge});

  Future<String> get() async {
    final expired = await checkIfExpired();
    if (expired) {
      print('$filename expired or nonexistant, fetching from $url');
      return forceFetch();
    } else {
      print('Loading cached copy of $filename');
      return readLocalFile(filename);
    }
  }

  Future<File> getCacheFile() async {
    return localFile(filename);
  }

  Future<bool> checkIfExpired() async {
    var file = await getCacheFile();
    return (file.existsSync())
        ? DateTime.now().difference(file.lastModifiedSync()) > maxAge
        : true;
  }

  Future<String> forceFetch() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('$url Fetched.');
      print('$url Updating cache...');
      await writeLocalFile(filename, response.body);
      return response.body;
    } else {
      print('$url Fetch failed (${response.statusCode}).');
      var file = await getCacheFile();
      if (file.existsSync()) {
        print('$url Using a cached copy.');
        return readLocalFile(filename);
      }
      return null;
    }
  }
}
