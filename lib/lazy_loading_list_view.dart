library lazy_loading_list_view;

/// Import required packages
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Defines a function that takes a page number and returns a Future of a List of items of type T
typedef ItemLoader<T> = Future<List<T>> Function(int page);

/// Defines a function that takes a BuildContext and an item of type T, and returns a Widget of type T
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

/// Defines a function that takes a BuildContext and returns a Widget for Shimmer loading effect
typedef ShimmerBuilder = Widget Function(BuildContext context);

/// StatefulWidget that builds a ListView which loads data lazily
class LazyLoadingListView<T> extends StatefulWidget {
  /// Function to load items
  final ItemLoader<T> loadItems;

  /// Function to build each item
  final ItemBuilder<T> buildItem;

  /// Function to build the shimmer effect
  final ShimmerBuilder? shimmerBuilder;

  final int pageSize;

  /// Constructor for the widget
  const LazyLoadingListView({
    Key? key,
    required this.loadItems,
    required this.buildItem,
    this.shimmerBuilder,
    this.pageSize = 10,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LazyLoadingListViewState<T> createState() => _LazyLoadingListViewState<T>();
}

class _LazyLoadingListViewState<T> extends State<LazyLoadingListView<T>> {
  /// List to hold the items
  final List<T> _items = [];

  /// Boolean to keep track if it's currently loading more items
  bool _loading = false;

  /// Boolean to keep track if there's more items to load
  bool _canLoadMore = true;

  /// The current page number
  int _currentPage = 0;

  /// The scroll controller used to detect if user reaches bottom of ListView
  final ScrollController _scrollController = ScrollController();

  /// Override the initState method to load more items at the start
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }

  /// Detects if user scrolls to bottom of ListView and loads more data
  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  /// Function to load more items
  void _loadMore() {
    /// Only load more items if it's not currently loading
    if (!_loading && _canLoadMore) {
      setState(() {
        _loading = true;
      });

      /// Load the items and then update the state
      widget.loadItems(_currentPage).then((newItems) {
        setState(() {
          _items.addAll(newItems);
          _currentPage++;
          _loading = false;
          _canLoadMore = newItems.length == widget.pageSize;
          _onScroll();
        });
      });
    }
  }

  /// This is the default shimmer effect if none is provided by the user
  Widget _defaultShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(height: 50, color: Colors.white),
    );
  }

  /// Override the build method to return the ListView
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: _items.length + (_loading ? 1 : 0),
      itemBuilder: (context, index) {
        /// Load more items if it reached the end of the list
        if (index == _items.length) {
          _loadMore();

          /// Display the shimmer effect while loading
          return widget.shimmerBuilder != null
              ? widget.shimmerBuilder!(context)
              : _defaultShimmer(context);
        }

        /// Build each item using the provided function
        return widget.buildItem(context, _items[index], index);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
