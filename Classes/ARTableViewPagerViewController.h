/* 
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
 */

#import <UIKit/UIKit.h>
#import "ARTableViewPagerView.h"


@protocol ARTableViewPagerDataSource <NSObject>

#pragma mark - Paging view data source

@required
- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@optional
- (NSInteger)pageIndex:(NSUInteger)pageIndex numberOfSectionsInTableView:(UITableView *)tableView;


- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (NSArray *)pageIndex:(NSUInteger)pageIndex sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

#pragma mark - Paging view delegate
@protocol ARTableViewPagerDelegate <NSObject>

@optional

// Display customization

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
- (UIView *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures). 

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
// Called after the user changes the selection.
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;               

// Indentation

- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

@end

@interface ARTableViewPagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ARTableViewPagerViewChanged, ARTableViewPagerDataSource, ARTableViewPagerDelegate> 

@property (strong, nonatomic, readonly) ARTableViewPagerView *tableViewPagerView;
@property (nonatomic, readonly) NSUInteger numberOfPages;

// this property is deprecated and will not be used anymore
@property (nonatomic) CGRect frame;

// controle the page control header
@property (nonatomic, strong) UIColor *pageControlBackgroundColor;
@property (nonatomic) BOOL hidePageControl;
@property (nonatomic) float pageControlHeight;

// set the background color auf the paging table
@property (nonatomic, strong) UIColor *fixedBackgroundColor; 
@property (nonatomic, strong) UIColor *scrollingBackgroundColor; //overrides the fixedBackgroundColor

// set Views used in the page control
@property (nonatomic, strong) NSArray *titleStrings; // using default views for the titles
@property (nonatomic, strong) NSArray *titleViews; // overrides the stings from titleStrings
@property (nonatomic, strong) UIView *leftArrowView;
@property (nonatomic, strong) UIView *rightArrowView;

- (id)initWithNumberOfPages:(NSUInteger)numberOfPages;
- (id)initWithTitleViews:(NSArray *)titleViews;
- (id)initWithTitleStrings:(NSArray *)titleStrings;

- (NSArray *)tableViews;
- (UITableView *)tableViewForPageIndex:(NSUInteger)pageIndex;
- (NSUInteger) currentPageIndex;
- (void)moveToPageAtIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end




