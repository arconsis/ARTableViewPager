ARTableViewPager
===============

The ARTableViewPager is an iOS component for horizontal table view scrolling/paging.

This component gives you the possibility to manage multiple UITableViews with one ViewController. To change the displayed table view you can either use a swipe gesture or the PageControl in the header. Its very easy to use just like the standard UITableViewController. You simply subclass ARTableViewPagerViewController!

![](https://github.com/arconsis/ARTableViewPager/raw/master/Screenshots/screenshot_1.png) -> ![](https://github.com/arconsis/ARTableViewPager/raw/master/Screenshots/screenshot_2.png) -> ![](https://github.com/arconsis/ARTableViewPager/raw/master/Screenshots/screenshot_3.png)

Please enjoy this framework!

Features:
-------

- manage multiple UITableViews with one ViewController
- horizontal scrolling/paging to switch between the table views
- very easy to use but also highly customizable
- supports all UITableView delegate methods with an additional parameter which contains the page index.
- uses ARC
- MIT open source licence

How to use
---------

1. Create a subclass of the `ARTableViewPagerViewController`

 	In your subclass you have to implement the delegate methods to setup the table views. The ARTableViewPager extents the UITableView delegate methods by the page index so you can setup the ViewController just like a normal UITableViewController but within the methods you can do something different for each page index.

 	With the `tableviews` or the `tableViewForPageIndex:` methods you can access the table views and do some additional configuration to them.

2. Create an instance of your Subclass with one of the initializers e.g. `initWithNumberOfPages:`

3. _optional:_ Configure the instance using the build in properties

4. Add it to the the screen.
 	_Note: If you use the ARTableViewPager with a UINavigationController you have to adjust the frame first by setting the frame property of the view controller like in the Simple Example._

Properties
--------

####titleStrings
Specify the title String for each page. If you use this property a default View is used to present the title.

####titleViews
Use your own View to present the title of the pages. This property overrides the titles from the `titleStrings` property. The size is automatically scaled to fit into the pageControl header. 

####leftArrowView
Customize the View displayed on the left side of the PageControl header. If this property is nil a default view is used.

####rightArrowView
Customize the View displayed on the right side of the pageControl header. If this property is nil a default view is used.

####pageControlBackgroundColor
The default background color of the pageControl header. 

####pageControlHeight
The height of the pageControl header. This property have to be set before the view is displayed on screen.

####hidePageControl
If set to YES no header is shown.

####fixedBackgroundColor
The background color behind the table views. It doesn't scroll whit the table views.

####scrollingBackgroundColor
The background color behind the table views. It overlays the `fixedBackgroundColor` and scrolls with the table views.
	
####numberOfPages
The total page count.

####tableViewPagerView
The view conturing the the paging control and the pageControl header.
	
####frame
The size of the View. Set this if you using  the ARTablePagerView as a subview.

Methods
-------

####initWithNumberOfPages
Initialize the TableViewPager with a number of Pages. It automatically creates the correct number of table views.

####initWithTitleViews
Initialize the TableViewPager with an array of Views containing the titles for each page.

####initWithTitleStrings
Initialize the TableViewPager with an array of title strings for each page.

####tableViews
Get the array of all used UITableViews. The position in the array corresponds with the index of the page the table view is displayed.

####tableViewForPageIndex
Get the specific UITableView  for a certain page index.

####currentPageIndex
Gives you the page index of the current displayed page.

####moveToPageAtIndex:animated
Changes the displayed page to the given page index. If animated is YES the change is animated with a swipe.

Licence
----------
 Copyright (c) 2012 arconsis IT-Solutions GmbH (http://www.arconsis.com )
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
 associated documentation files (the "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
 following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial 
 portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
 LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
 NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
