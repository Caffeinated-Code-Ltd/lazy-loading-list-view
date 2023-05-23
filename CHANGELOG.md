## 0.0.1

Provides ability to lazy load and paginate data within a ListView.

## 0.0.2

You can now specify a pageSize, defaults to 10.
The buildItem function now provides the current item index.
The LazyLoadingListView now uses a scrollController to detect when user reaches bottom of ListView.
LazyLoadingListView now detects when there is no more data to load.

## 0.0.3

Now includes pull-to-refresh functionality without any additional setup by the user.
Now includes a default empty state with option to override with your own Widget.
Removed Shimmer dependency from package and replaced the default loading style to use a CircularProgressIndicator instead.
Swapped ListView.builder out in favour of ListView.separated.
User can now override the default separatorBuilder to create there own custom separator style.

# 0.0.4

Updated README.md to display example gifs

# 0.0.5

Updated README.md