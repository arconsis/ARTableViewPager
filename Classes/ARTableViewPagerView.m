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

#import "ARTableViewPagerView.h"

@interface ARTableViewPagerView ()

@property (nonatomic, strong) ARTableViewPagerPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic) BOOL pageControlBeingUsed;

- (void)pageChangedToTableView:(UITableView *)tableview withPageIndex:(NSUInteger)pageIndex;
- (void)setupTitleViewsForPageIndex:(NSUInteger)pageIndex;
- (void)setupDefaultTitleViews;
@end

@implementation ARTableViewPagerView
@synthesize delegate = _delegate;
@synthesize pageControl = _pageControl;
@synthesize hidePageControl = _hidePageControl;
@synthesize pageControlHeight = _pageControlHeight;
@synthesize scrollView = _scrollView;

@synthesize titleViews = _titleViews;
@synthesize leftArrowView = _leftArrowView;
@synthesize rightArrowView = _rightArrowView;

@synthesize arrowDefaultColor = _arrowDefaultColor;
@synthesize pageControlBackgroundColor = _pageControlBackgroundColor;
@synthesize scrollingBackgroundColor = _scrollingBackgroundColor;
@synthesize fixedBackgroundColor = _fixedBackgroundColor;
@synthesize titleDefaultLabelColor = _titleDefaultLabelColor;
@synthesize titleDefaultLabelStrings = _titleDefaultLabelStrings;

@synthesize pageControlBeingUsed = _pageControlBeingUsed;

- (void)initializeLayout {
    
    // The frame must be set previsously when creating the view and can't be changed!
    self.backgroundColor = self.fixedBackgroundColor ? self.fixedBackgroundColor : [UIColor scrollViewTexturedBackgroundColor];
    
    float usedPageControlHeight = self.pageControlHeight ? self.pageControlHeight : PAGECONTROL_DEFAULT_HEIGHT;
    
    if (self.hidePageControl) {
        usedPageControlHeight = 0;
    }
    
    self.pageControl = [[ARTableViewPagerPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, usedPageControlHeight)];
    self.pageControl.showTitles = (self.titleViews == nil || [self.titleViews count] == 0) && (self.titleDefaultLabelStrings == nil || [self.titleDefaultLabelStrings count] == 0) ? NO : YES;
    if (self.pageControlBackgroundColor) {
        self.pageControl.backgroundColor = self.pageControlBackgroundColor;
    }
    
    [self.pageControl addTarget:self action:@selector(pageControlChangePage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(self.pageControl.bounds.origin.x, self.pageControl.bounds.origin.y + usedPageControlHeight, self.bounds.size.width, self.bounds.size.height - usedPageControlHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.backgroundColor = self.scrollingBackgroundColor ? self.scrollingBackgroundColor : [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.scrollView];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.directionalLockEnabled = YES;
    self.pageControlBeingUsed = NO;
    
    if (!self.titleViews && self.titleDefaultLabelStrings) {
        [self setupDefaultTitleViews];
    }
    
    [self setupTitleViewsForPageIndex:0];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {    
    }
    return self;
}

#pragma mark - Handle scrolling

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!self.pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int pageIndex = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        // Set boundaries if values are out of range
        pageIndex = pageIndex < 0 ? pageIndex = 0 : pageIndex;
        pageIndex = pageIndex > self.pageControl.numberOfPages - 1 ? self.pageControl.numberOfPages - 1 : pageIndex;
        
        // callback to delegate
        if (self.pageControl.currentPage != pageIndex) {
            UITableView *tableview = [self.scrollView.subviews objectAtIndex:pageIndex];
            [self pageChangedToTableView:tableview withPageIndex:pageIndex];
        }
        
        self.pageControl.currentPage = pageIndex;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.pageControlBeingUsed = NO;
    self.scrollView.scrollEnabled = YES;
 }

- (void) pageControlChangePage{
    [self pageControlChangePage:YES];
}

- (void) pageControlChangePage:(BOOL)animated {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:animated];

	self.pageControlBeingUsed = YES;
    
    // callback to delegate
    UITableView *tableview = [self.scrollView.subviews objectAtIndex:self.pageControl.currentPage];
    [self pageChangedToTableView:tableview withPageIndex:self.pageControl.currentPage];
}

- (UIView *)defaultArrowView:(NSString *)arrowString; {
    UILabel *r = [[UILabel alloc] init];
    r.text = arrowString;
    r.textColor = self.arrowDefaultColor ? self.arrowDefaultColor : [UIColor blackColor];        
    r.font = [UIFont boldSystemFontOfSize:18];
    r.textAlignment = UITextAlignmentRight;
    r.backgroundColor = [UIColor clearColor];
    return r;
}

- (void)setupTitleViewsForPageIndex:(NSUInteger)pageIndex {
    [[self.pageControl.leftView.subviews lastObject] removeFromSuperview];
    [[self.pageControl.rightView.subviews lastObject] removeFromSuperview];
    [[self.pageControl.centerView.subviews lastObject] removeFromSuperview];
    
    if (self.titleViews && pageIndex > 0) {        
        UIView *l = self.leftArrowView ? self.leftArrowView : [self defaultArrowView:@" <"]; 
        [self.pageControl.leftView addSubview:l];
        l.frame = self.pageControl.leftView.bounds;
    }
    
    if (self.titleViews && pageIndex < self.pageControl.numberOfPages - 1) {
        UIView *r = self.rightArrowView ? self.rightArrowView : [self defaultArrowView:@"> "];        
        [self.pageControl.rightView addSubview:r];
        r.frame = self.pageControl.rightView.bounds;
    }
    
    UIView *c = [self.titleViews objectAtIndex:pageIndex];
    [self.pageControl.centerView addSubview:c];
    c.frame = self.pageControl.centerView.bounds;
}

-(void)pageChangedToTableView:(UITableView *)tableview withPageIndex:(NSUInteger)pageIndex {
    [self setupTitleViewsForPageIndex:pageIndex];
    [self.delegate pageChangedToTableView:tableview withPageIndex:pageIndex];
}

- (void)setupDefaultTitleViews {
    self.titleViews = [NSMutableArray arrayWithCapacity:[self.titleDefaultLabelStrings count]];
    for (NSString *title in self.titleDefaultLabelStrings) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = self.titleDefaultLabelColor ? self.titleDefaultLabelColor : [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self.titleViews addObject:label];
    }
}

@end
