import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:service_worker/worker.dart' as sw;
import 'async_resource.dart';


/// Represents storage options for a browser.
class SwBrowserResource<T> extends AsyncResource<T> {
  SwBrowserResource(this.name, this.url, {Parser<T> parse})
      : super(parse: parse);

  /// The name of the cache to use.
  final String name, url;
  sw.Cache _cache;

  Future<sw.Cache> get cache async => _cache ??= await sw.caches.open(name);
  Future<sw.Response> get contentResponse async => (await cache).match(url);
  Future<sw.Response> get modTimeResponse async =>
      (await cache).match(url + '/modTime');

  @override
  Future<bool> get exists async => (await contentResponse).ok;

  @override
  Future fetchContents() async => (await contentResponse).body;

  @override
  Future<DateTime> get lastModified async {
    final modTime = await modTimeResponse;
    return modTime.ok ? DateTime.parse(modTime.body) : null;
  }

  @override
  Future<void> write(contents) async {
    final c = await cache;
//    c.add(sw.Request(''));
//    c.put(path + '/modTime', sw.Response(DateTime.now()));
  }
}
