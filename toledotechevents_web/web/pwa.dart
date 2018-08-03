import 'package:pwa/worker.dart';

import 'package:toledotechevents_web/pwa/offline_urls.g.dart' as offline;

void main() {
  final cache = DynamicCache('toledotechevents_events', maxAge: Duration(minutes: 60));
  Worker()
    ..offlineUrls = offline.offlineUrls
  ..router.registerGetUrl('', cache.cacheFirst)
  ..run(version: offline.lastModified);
}