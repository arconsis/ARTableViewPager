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
#import "ARTableViewPagerPageControl.h"

#define PAGECONTROL_DEFAULT_HEIGHT 36
@protocol ARTableViewPagerViewChanged <NSObject>

- (void)pageChangedToTableView:(UITableView *)tableview withPageIndex:(NSUInteger)pageIndex;

@end

@interface ARTableViewPagerView : UIView <UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) id <ARTableViewPagerViewChanged> delegate;

@property (nonatomic, strong, readonly) ARTableViewPagerPageControl *pageControl;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// specify the content of the pageControl
@property (nonatomic, strong) NSMutableArray *titleDefaultLabelStrings;
@property (nonatomic, strong) NSMutableArray *titleViews; //overrides titleDetaultLabelStrings
@property (nonatomic, strong) UIView *leftArrowView;
@property (nonatomic, strong) UIView *rightArrowView;

@property (nonatomic, strong) UIColor *pageControlBackgroundColor;
@property (nonatomic, strong) UIColor *scrollingBackgroundColor;
@property (nonatomic, strong) UIColor *fixedBackgroundColor; // overrides scrollingBackgroundColor
@property (nonatomic, strong) UIColor *titleDefaultLabelColor;
@property (nonatomic, strong) UIColor *arrowDefaultColor;

@property (nonatomic) BOOL hidePageControl;
@property (nonatomic) float pageControlHeight;

- (void)initializeLayout;
- (void)pageControlChangePage:(BOOL)animated;

@end