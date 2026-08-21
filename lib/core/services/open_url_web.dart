/// Opens an external or same-origin URL on web.
library;

import 'dart:js_interop';

@JS('window.open')
external JSAny? _windowOpen(String url, String target);

/// Opens [url] in a new tab. Returns true when invoked.
bool openUrl(String url) {
  if (url.trim().isEmpty) return false;
  _windowOpen(url, '_blank');
  return true;
}
