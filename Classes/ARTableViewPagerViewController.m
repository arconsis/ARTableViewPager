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

#import "ARTableViewPagerViewController.h"

@interface ARTableViewPagerViewController ()

@property (nonatomic, strong) NSMutableArray *internalTableViews;
@property (strong, nonatomic) ARTableViewPagerView *tableViewPagerView;
@property (nonatomic) NSUInteger numberOfPages;

@end


@implementation ARTableViewPagerViewController

@synthesize tableViewPagerView = _tableViewPagerView;
@synthesize numberOfPages = _numberOfPages;
@synthesize internalTableViews = _internalTableViews;

@synthesize titleViews = _titleViews;
@synthesize leftArrowView = _leftArrowView;
@synthesize rightArrowView = _rightArrowView;
@synthesize titleStrings = _titleStrings;

@synthesize pageControlBackgroundColor = _pageControlBackgroundColor;
@synthesize scrollingBackgroundColor = _scrollingBackgroundColor;
@synthesize fixedBackgroundColor = _fixedBackgroundColor;

@synthesize hidePageControl = _hidePageControl;
@synthesize pageControlHeight = _pageControlHeight;

#pragma mark - paging

- (id)initWithTitleStrings:(NSArray *)titleStrings {
    
    self = [self initWithNumberOfPages:[titleStrings count]];
    if (self) {
        self.titleStrings = titleStrings;
    }
    
    return self;
}

- (id)initWithTitleViews:(NSArray *)titleViews {

    self = [self initWithNumberOfPages:[titleViews count]];
    
    if (self) {
        self.titleViews = titleViews;
    }
    
    return self;
}

- (id)initWithNumberOfPages:(NSUInteger)numberOfPages {

    if (self = [super init]) {
        self.numberOfPages = numberOfPages;
        self.internalTableViews = [NSMutableArray arrayWithCapacity:numberOfPages];
    }
    return self;
    
}

#pragma mark - View lifecycle

- (void)loadView {
    ARTableViewPagerView *pagingTableView = [[ARTableViewPagerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = pagingTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![self.view isKindOfClass:[ARTableViewPagerView class]]) {
        NSLog(@"Configuration Warning: View for PagingTableViewController must be of type PagingTableView! Setting default view.");
        self.view = [[ARTableViewPagerView alloc] initWithFrame:self.view.bounds];
    }

    self.tableViewPagerView = (ARTableViewPagerView *)self.view;
    
    // Need to init the pagingTableView first with size and labels
    self.tableViewPagerView.titleViews = [self.titleViews mutableCopy];
    self.tableViewPagerView.titleDefaultLabelStrings = [self.titleStrings mutableCopy];
    self.tableViewPagerView.rightArrowView = self.rightArrowView;
    self.tableViewPagerView.leftArrowView = self.leftArrowView;
    self.tableViewPagerView.pageControlBackgroundColor = self.pageControlBackgroundColor;
    self.tableViewPagerView.fixedBackgroundColor = self.fixedBackgroundColor;
    self.tableViewPagerView.scrollingBackgroundColor = self.scrollingBackgroundColor;
    self.tableViewPagerView.hidePageControl = self.hidePageControl ? self.hidePageControl : NO;
    self.tableViewPagerView.pageControlHeight = self.pageControlHeight;
    
    self.tableViewPagerView.delegate = self;

    [self.tableViewPagerView initializeLayout];
    
    // Now create the subview tableviews in the scrollView
    UIScrollView *scrollView = self.tableViewPagerView.scrollView;
    UIPageControl *pageControl = self.tableViewPagerView.pageControl;
	
	for (int i = 0; i < self.numberOfPages; i++) {
		CGRect frame;
		frame.origin.x = scrollView.frame.size.width * i;
		frame.origin.y = 0; 
		frame.size = scrollView.frame.size;
		
		UITableView *subview = [[UITableView alloc] initWithFrame:frame];
        subview.dataSource = self;
        subview.delegate = self;
        subview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
		[scrollView addSubview:subview];
        [self.internalTableViews insertObject:subview atIndex:i];
	}
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.numberOfPages, scrollView.frame.size.height);
    
    pageControl.currentPage = 0;
	pageControl.numberOfPages = self.numberOfPages;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableViewPagerView.scrollView.contentSize = CGSizeMake(self.tableViewPagerView.scrollView.frame.size.width * self.numberOfPages, self.tableViewPagerView.scrollView.frame.size.height);

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setTableViewPagerView:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark - Public methods to use in subclass
- (NSArray *)tableViews {
    return [NSArray arrayWithArray:self.internalTableViews];
}

- (UITableView *)tableViewForPageIndex:(NSUInteger)pageIndex {
    return [self.internalTableViews objectAtIndex:pageIndex];
}

- (NSUInteger)currentPageIndex {
    return self.tableViewPagerView.pageControl.currentPage;
}

- (void)moveToPageAtIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex < self.numberOfPages) {
        self.tableViewPagerView.pageControl.currentPage = pageIndex;
        [self.tableViewPagerView pageControlChangePage:animated];
    }
}


#pragma mark - Paging view delegate for receiving notifications on page change
-(void)pageChangedToTableView:(UITableView *)tableview withPageIndex:(NSUInteger)pageIndex {

}


#pragma mark - Paging view data source to override in subclass
- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

// optionals 
- (NSInteger)pageIndex:(NSUInteger)pageIndex numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}


- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


// Editing

- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// Moving/reordering

- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// Index

- (NSArray *)pageIndex:(NSUInteger)pageIndex sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

// Data manipulation - reorder / moving support

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

}



#pragma mark - Paging view delegate
#pragma mark - Paging Table View delegate methods
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// Variable height support

- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both
- (UIView *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
}

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return nil;
}

// Indentation

- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}



#pragma mark - Table view data source. Delegate all method calls to subclass and include pageIndex.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of sections.
    return [self pageIndex:tableViewIndex numberOfSectionsInTableView:tableView];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView titleForHeaderInSection:section];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView titleForFooterInSection:section];
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView canEditRowAtIndexPath:indexPath];
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView canMoveRowAtIndexPath:indexPath];
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex sectionIndexTitlesForTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
}

// Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    [self pageIndex:tableViewIndex tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}
// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    [self pageIndex:tableViewIndex tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - Table view data source. Delegate all method calls to subclass and include pageIndex.

//@optional

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return the number of rows in the section.
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    return [self pageIndex:tableViewIndex tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView heightForFooterInSection:section];
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView viewForFooterInSection:section];
}

// Accessories (disclosures). 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView willSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView willDeselectRowAtIndexPath:indexPath];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    [self pageIndex:tableViewIndex tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSUInteger tableViewIndex = [self.internalTableViews indexOfObject:tableView];
    // Return the number of rows in the section.
    return [self pageIndex:tableViewIndex tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}

@end
