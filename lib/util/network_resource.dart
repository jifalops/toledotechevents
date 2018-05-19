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
    return file == null
        ? true
        : file.lastModifiedSync().difference(DateTime.now()) > maxAge;
  }

  Future<String> forceFetch() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('$url fetched.');
      print('$url updating cache');
      await writeLocalFile(filename, response.body);
      return response.body;
    } else {
      print('$url fetch failed! Response: $response');
      return null;
    }
  }
}
