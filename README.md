# Manager's Special

Manager's Special is an app which displays the current manager's specials for an unspecified grocery store. It is designed to be compatible with all iOS devices running iOS 14.5 or later.

The specials data is obtained in JSON format from an endpoint of a RESTful web service. The endpoint describes each product on special, including the dimensions of the "tile" in which it should be displayed, which are given in dimensionless canvas units. It also specifies how many of these unitless increments span the width of the screen, so the dimensions can be converted to points.

### Table of Contents

- [Installation](#installation)
- [Design Decisions](#design-decisions)
- [Future Work](#future-work)

## Installation

Follow these steps to build and run Manager's Special:

1. Clone this repo to your Mac.

    ```
    git clone https://github.com/toddthomas/ManagersSpecial.git
    cd ManagersSpecial
    ```

2. Open the project file in Xcode 12.5.

    ```
    open ManagersSpecial.xcodeproj
    ```
    
3. Assign the ManagersSpecial target to a team available on your Mac. You can find instructions on how to do that by clicking the Help menu and typing "assign a project to a team" into the search field.

4. Choose your favorite simulator or connected device, and build and run the ManagersSpecial scheme.

## Design decisions
### SwiftUI
I chose to implement the app in SwiftUI because I wanted to gain further experience with that framework.

### Tile layout
As SwiftUI currently (and infamously) lacks a collection view like UIKit's, I had to figure out how to lay out the product tiles. I tried several different strategies, but the one that ultimately gave the best results was to first chunk the list of product tiles provided by the endpoint into subsequences of tiles whose widths summed to no more than the specified width of the screen in canvas units. This chunking is performed by an extension of `Collection` I wrote: `chunkedByReduction(into:_)`, which takes a reducing predicate trailing closure to determine which elements of a collection should be chunked together. I intend to submit this extension in a pull request to the [swift-algorithms](https://github.com/apple/swift-algorithms) package, which contains some other collection-chunking methods, to see if the maintainers think it merits inclusion there.

I then defined a view that horizontally stacked each tile view in such a subsequence, which became a row in a scrollable lazy vertical stack.

A crucial aspect of this strategy is that the product tile view uses `GeometryReader` to inset its contents (the product image and the price and description text) into a frame of the exact dimensions specified by the endpoint. The inset becomes the spacing between tiles. That was the only technique I found that preserved the aspect ratio and exact dimensions (minus spacing) specified by the endpoint for each tile.

### What to display for each product
Some products in the list provided by the endpoint have the same original and current price—i.e., they are not discounted. I decided it didn't make sense to display the original price for a non-discounted item, so the customer doesn't immediately question what's so special about it.

### Handling very small tiles
Some products are specified with very small tiles—for example, 3 x 3 canvas units. On most iPhones, 5 units wide is too narrow to display both the product image and the price text side-by-side. 3 units is too narrow to display the price alone.

I decided to omit the image from the tile on phones when the tile is 5 units wide or less. Only the price and description are shown in that case. When the tile is 3 units wide or less on a phone, since there's not room to show the price, let alone the text description of the item, I decided to instead show only the image. I think the image has the best chance of communicating what item is on special when the tile is that small. I imagine that in a fully-featured version of this app, the user could tap on the tile to see a full screen of details about the item.

### Image loading
I used [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) for asynchronous loading and caching of web-based images. I enjoyed using the UIKit version of that framework on a previous project, and I found the SwiftUI version to be even more delightful.

### Resizable images
The provided mockup shows the product image having the same size on the two different tile sizes depicted. But those two tile sizes are not that different in terms of the area they make available for a rectangular image. The endpoint provides a much greater range of tile sizes and aspect ratios, and I found that allowing SwiftUI to resize the image made better use of the available space.

### Font sizes
I used built-in text styles, as I'm in the habit of doing so to allow the use of Dynamic Type. I used the styles that seemed closest to the font sizes and weights shown in the mockup, but for the prices in particular I don't have an exact match.

That being said, this app doesn't work well with Dynamic Type, at least on smaller phones, because the size of the tiles has a fixed specification. To take advantage of Dynamic Type, the tiles would need to be allowed to grow larger as the type size increases.

### Adaptability to different screen sizes
I tested the app in the simulator on all the different screen sizes available for iOS 14.5, from the iPod Touch to the 12.9" iPad Pro. It looks best on phones; on iPads, the tiles would need to be reconfigured to take best advantage of the extra space. I experimented with doubling the canvas unit to 32 across the screen width, which allowed the iPad to show roughly twice as many tiles per screen—somewhat like having two phones side-by-side—but the arrangement of different tile shapes next to each other wasn't as pleasing.

The app also adapts to landscape mode, and in fact that's a nice way to see more detail on smaller tiles.

### Data update strategy
Since the specials can change at any time, how should an update be triggered? My preference would be via push notification, but that’s out of scope for this exercise.

In lieu of push notification, I would choose a combination of:
* update from the endpoint every time the app will enter the foreground;
* poll occasionally--perhaps on a 5 minute interval? Greater than about 10 minutes and the customer might miss an update during their visit to the store;
* pull-to-refresh? I believe it’s a well-known interaction that might be expected in this context.

Of the three, I only attempted to implement the first. That took the form of performing an update of the app's local data store within the closure passed to an `onAppear(_:)` modifier applied to the root view of the app. However, in my testing, that closure was only executed once during any app runtime. I need to research whether there's a way in the SwiftUI app lifecycle to hook into an event triggered whenever the app comes to the foreground.

I didn't attempt polling or pull-to-refresh because it wouldn't have been straightforward to test, as the data at the endpoint never changed while I was developing the app. I felt my time was better spent elsewhere.

## Future work
I need to investigate why the rows of tiles don't have the leading and trailing padding I thought I gave them.

I'd like the area on top of the safe area to be handled more elegantly—something like a translucent material that the specials would scroll under. I haven't yet researched how to do that.
