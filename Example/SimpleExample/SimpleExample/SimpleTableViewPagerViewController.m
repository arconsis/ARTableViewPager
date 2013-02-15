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

#import "SimpleTableViewPagerViewController.h"

@implementation SimpleTableViewPagerViewController

@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.

    self.data = [NSArray arrayWithObjects:
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD",
                 @"AAA", @"BBB", @"CCC", @"DDD", nil];

    UITableView *tableViewPage0 = [self tableViewForPageIndex:0];
    tableViewPage0.separatorColor = [UIColor redColor];
    tableViewPage0.backgroundColor = [UIColor yellowColor];

    UITableView *tableViewPage1 = [self tableViewForPageIndex:1];
    tableViewPage1.separatorColor = [UIColor blueColor];
    tableViewPage1.backgroundColor = [UIColor greenColor];

    // Insert a Button to move to the first page programmatically
    UIBarButtonItem *goToFirstPage = [[UIBarButtonItem alloc] initWithTitle:@"1st page"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(goToFirstPage)];
    self.navigationItem.leftBarButtonItem = goToFirstPage;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goToFirstPage
{
    [self moveToPageAtIndex:0 animated:YES];
}

#pragma mark - Paging view data source

- (NSInteger)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}


- (UITableViewCell *)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSString *d = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %d", d, pageIndex];

    return cell;
}

#pragma mark - Paging view delegate
- (void)pageIndex:(NSUInteger)pageIndex tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *d = [self.data objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:[NSString stringWithFormat:@"%@ : %d", d, pageIndex]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
