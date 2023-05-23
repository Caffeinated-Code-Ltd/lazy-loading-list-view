A package for creating a ListView that handles lazy loading, pagination, pull-to-refresh, and a custom empty state.

https://github.com/Caffeinated-Code-Ltd/lazy-loading-list-view/doc/example_1.gif?raw=true
https://github.com/Caffeinated-Code-Ltd/lazy-loading-list-view/doc/example_2.gif?raw=true

## Features

Add this to your Flutter app to:

1. Create all ListView's throughout your project using a single reusable widget.
2. Handle pagination within ListView's by simply calling a function to load more data.
3. Provides a default loading state when fetching more data. User can override this by providing there own loadingStateBuilder.
4. Provides a default empty state when no data is returned. User can override this by providing there own emptyState Widget.
5. Automatically handles pull-to-refresh functionality.

## Usage

Install the LazyLoadingListView package by adding the following to your project dependencies within the pubspec.yaml file:

```dart  
lazy_loading_list_view: ^0.0.3  
```  

Add the following to the top of your file:

```dart  
import 'package:lazy_loading_list_view/lazy_loading_list_view.dart';
```  

Create a LazyLoadingListView using the example below:

```dart  
LazyLoadingListView<MyData>(  
    loadItems: (int page) async { 
        // your function to load data for the given page 
        return await getData(page: page);
    }, 
    buildItem: (BuildContext context, MyData item, int index) { 
        // your function to build list item 
        return MyCustomListItem(item: item); 
    }, 
)  
```  

You can also customize the LazyLoadingListView further by overriding the separatorBuilder, loadingStateBuilder, emptyState, and pageSize:

```dart  
LazyLoadingListView<MyData>(  
    loadItems: (int page) async { 
        // your function to load data for the given page 
        return await getData(page: page);
    }, 
    buildItem: (BuildContext context, MyData item, int index) { 
        // your function to build list item 
        return MyCustomListItem(item: item); 
    }, 
    separatorBuilder: (context, index) {
        // define your own separator
        return const SizedBox(height: 10);
    },
    loadingStateBuilder: (context) {
        // your function to build a custom loading state
        return const MyCustomLoadingState();
    },
    // provide your custom empty state widget
    emptyState: MyEmptyState(),
    // define your preferred page size
    pageSize: 10,
)  
```  

## Bugs or Feature Requests

If you encounter any problems feel free to open an issue.   
If you feel the library is missing a feature that would be helpful, please raise a ticket on GitHub and we will look into it.

## Additional information

This package was created by Caffeinated Code Ltd. If you find this package useful, you can support it for free by giving it a thumbs up at the top of this page. Here's another option to support the package:

<a href="https://www.buymeacoffee.com/andrewsteven" rel="ugc"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&amp;emoji=&amp;slug=andrewsteven&amp;button_colour=5F7FFF&amp;font_colour=ffffff&amp;font_family=Cookie&amp;outline_colour=000000&amp;coffee_colour=FFDD00"></a>