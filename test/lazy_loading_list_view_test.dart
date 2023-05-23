// Import flutter_test package
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazy_loading_list_view/lazy_loading_list_view.dart';

void main() {
  /// This is the mock data we'll use for testing
  const mockData = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  Future<List<String>> mockLoader(int page) async {
    /// Emulate delay of network or database
    await Future.delayed(const Duration(seconds: 1));
    return page <= 2 ? mockData : [];
  }

  Widget mockBuilder(BuildContext context, String item, int index) {
    return Text(item);
  }

  Widget mockShimmerBuilder(BuildContext context) {
    return const CircularProgressIndicator();
  }

  testWidgets('LazyLoadingListView loads and displays items correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LazyLoadingListView(
        loadItems: mockLoader,
        buildItem: mockBuilder,
      ),
    ));

    /// Wait for the loading to finish
    await tester.pumpAndSettle(const Duration(seconds: 2));

    /// Validate that the ListView is present
    expect(find.byType(ListView), findsOneWidget);

    /// Validate that the items are correctly loaded
    for (var item in mockData) {
      expect(find.text(item), findsWidgets);
    }
  });

  testWidgets('LazyLoadingListView displays default loading state when loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LazyLoadingListView(
        loadItems: mockLoader,
        buildItem: mockBuilder,
      ),
    ));

    /// Validate that default loading state is displayed when loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    /// Wait for the loading to finish
    await tester.pumpAndSettle(const Duration(seconds: 2));

    /// Validate that the shimmer effect is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('LazyLoadingListView displays custom loading state while loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LazyLoadingListView(
        loadItems: mockLoader,
        buildItem: mockBuilder,
        loadingStateBuilder: mockShimmerBuilder,
      ),
    ));

    /// Validate that the custom shimmer effect is displayed while loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    /// Wait for the loading to finish
    await tester.pumpAndSettle(const Duration(seconds: 2));

    /// Validate that the shimmer effect is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
