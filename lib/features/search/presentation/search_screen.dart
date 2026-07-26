/// Search presentation layer.
///
/// **Why:** UI for query input and result lists.
/// **Owner:** Search feature team.
/// **When:** Implement after projects catalog data is queryable.
library;

import 'package:flutter/material.dart';

/// Placeholder search screen.
///
/// TODO(search): Build search field, filters, and results list.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(search): Handle loading / empty / error / success for query results.
    return const Scaffold(
      body: Center(child: Text('Search — TODO')),
    );
  }
}
