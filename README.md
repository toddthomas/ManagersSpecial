# Manager's Special

Manager's Special is an app for all iOS devices running iOS 14.5 or later, which displays the current manager's specials for an unspecified grocery store. The specials data is obtained in JSON format from an endpoint of a RESTful web service. The endpoint describes each product on special, including the dimensions of the "tile" in which it should be displayed, which are given in dimensionless canvas units. It also specifies how many of these unitless increments span the width of the screen, so the dimensions can be converted to points.

## Design decisions
### SwiftUI
I chose to implement the app in SwiftUI because I wanted to gain further
experience with that framework.

### What to display for each product
Some products in the list provided by the endpoint have the same original and current price—i.e., they are not discounted. I decided it didn't make sense to display the original price for a non-discounted item, so the customer doesn't immediately question what's so special about it.

### Handling very small tiles
Some products are specified with very small tiles—for example, 3 x 3 canvas units. On most iPhones, 5 units wide is too narrow to display both the product image and the price text side-by-side. 3 units is too narrow to display the price alone.

I decided to omit the image from the tile on phones when the tile is 5 units wide or less. Only the price and description are shown in that case. When the tile is 3 units wide or less on a phone, since there's not room to show the price, let alone the text description of the item, I decided to instead show only the image. I think the image has the best chance of communicating what item is on special when the tile is that small. I imagine that in a fully-featured version of this app, the user could tap on the tile to see a full screen of details about the item.

### Resizable images
The provided mockup shows the product image having the same size on the two different-sized tiles depicted. But those two tile sizes are not that different in terms of the area they make available for a rectangular image. The endpoint provides a much greater range of tile sizes and aspect ratios, and I found that allowing SwiftUI to resize the image made better use of the available space.

### Data update strategy
Since the specials can change at any time, how should an update be triggered? My preference would be via push notification, but that’s out of scope for this exercise, even though it’s my strong preference.

In lieu of push notification, I would choose a combination of:
* update from the endpoint every time the app will enter the foreground;
* poll occasionally--perhaps on a 5 minute interval? Greater than about 10 minutes and the customer might miss an update during their visit to the store;
* pull-to-refresh? I believe it’s a well-known interaction that might be expected in this context.

Of the three, I only attempted to implement the first. That took the form of performing an update of the app's local data store from the endpoint within the closure passed to an `onAppear(_:)` modifier applied to the root view of the app. However, in my testing, that closure was only executed once during any app runtime. I need to research whether there's a way in the SwiftUI app lifecycle to hook into an event triggered whenever the app comes to the foreground.

I didn't attempt polling or pull-to-refresh because it wouldn't have been straightforward to test, as the data at the endpoint never changed while I was developing the app. I felt my time was better spent elsewhere.

### Tile layout
As SwiftUI currently (and infamously) lacks a collection view like UIKit's, I had to figure out how to lay out the product tiles. I tried several different strategies, but the one that ultimately gave the best results was to first chunk the list of product tiles provided by the endpoint into subsequences of tiles whose widths summed to no more than the specified width of the screen in canvas units. This chunking is performed by an extension of `Collection` I wrote: `chunkedByReduction(into:_)`, which takes a reducing predicate to determine which elements of a collection should be chunked together. I intend to submit this extension in a pull request to the [swift-algorithms](https://github.com/apple/swift-algorithms) package, which contains some other collection-chunking methods, to see if the maintainers think it merits inclusion there.

I then defined a view that stacked each tile view in such a subsequence horizontally, which became a row in a scrollable lazy vertical stack.

A crucial aspect of this strategy is that the product tile view uses `GeometryReader` to inset its contents (the product image and the price and description text) into a frame of the exact dimensions specified by the endpoint. The inset becomes the spacing between tiles. That was the only technique I found that preserved the aspect ratio and exact dimensions (minus spacing) specified by the endpoint for each tile.

## Future work
I need to investigate why the rows of tiles don't have the leading and trailing padding I thought I gave them.

I'd like the area on top of the safe area to be handled more elegantly—something like a translucent material that the specials would scroll under. I haven't yet researched how to do that.
