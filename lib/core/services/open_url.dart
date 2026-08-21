/// Platform URL opener — web opens a new tab; other platforms no-op.
library;

export 'package:rsprojects_showcase/core/services/open_url_io.dart'
    if (dart.library.js_interop) 'package:rsprojects_showcase/core/services/open_url_web.dart';
