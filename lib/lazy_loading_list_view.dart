library lazy_loading_list_view;

/// Import required packages
import 'package:flutter/material.dart';

/// Defines a function that takes a page number and returns a Future of a List of items of type T
typedef ItemLoader<T> = Future<List<T>> Function(int page);

/// Defines a function that takes a BuildContext and an item of type T, and returns a Widget of type T
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

/// Defines a function that takes a BuildContext and returns a Widget
typedef LoadingStateBuilder = Widget Function(BuildContext context);

/// StatefulWidget that builds a ListView which loads data lazily
class LazyLoadingListView<T> extends StatefulWidget {
  /// Function to load items
  final ItemLoader<T> loadItems;

  /// Function to build each item
  final ItemBuilder<T> buildItem;

  /// Function to build the optional separator
  final IndexedWidgetBuilder? separatorBuilder;

  /// Function to build the loading state
  final LoadingStateBuilder? loadingStateBuilder;

  /// Optional widget to display as the empty state
  final Widget? emptyState;

  /// Defines the page size for loading data. Defaults to 10.
  final int pageSize;

  /// Constructor for the widget
  const LazyLoadingListView({
    Key? key,
    required this.loadItems,
    required this.buildItem,
    this.separatorBuilder,
    this.loadingStateBuilder,
    this.emptyState,
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
  Future<void> _loadMore() async {
    /// Only load more items if it's not currently loading and there is more data to load
    if (!_loading && _canLoadMore) {
      setState(() {
        _loading = true;
      });

      /// Load the items and then update the state
      widget.loadItems(_currentPage).then((newItems) {
        setState(() {
          _items.addAll(newItems);
          _currentPage++;
          _canLoadMore = newItems.length == widget.pageSize;
          _loading = false;
        });
      });
    }
  }

  /// This is the default loading state if none is provided by the user
  Widget _defaultLoader(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
    );
  }

  bool get _isEmptyState =>
      _items.isEmpty && _canLoadMore == false && _loading == false;

  /// This is the default empty state if none is provided by the user
  Widget _defaultEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Looks like there is no data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async => await _handleRefresh(),
            child: Text(
              'Refresh',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  /// Function to handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      _items.clear();
      _currentPage = 0;
      _canLoadMore = true;
      _loading = false;
    });
    _loadMore();
  }

  /// Build the ListView
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _handleRefresh(),
      child: !_isEmptyState
          ? ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _items.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                /// Load more items if it reached the end of the list
                if (index == _items.length) {
                  /// Display the shimmer effect while loading
                  return widget.loadingStateBuilder != null
                      ? widget.loadingStateBuilder!(context)
                      : _defaultLoader(context);
                }

                /// Build each item using the provided function
                return widget.buildItem(context, _items[index], index);
              },

              /// Checks to see if user has provided a separator builder, else shows nothing
              separatorBuilder: widget.separatorBuilder ??
                  (context, index) {
                    return const SizedBox.shrink();
                  },
            )
          : widget.emptyState ?? _defaultEmptyState(context),
    );
  }

  /// Dispose of the scroll controller
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
