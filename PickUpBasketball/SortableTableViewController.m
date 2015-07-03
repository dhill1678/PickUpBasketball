/*
 *  ViewController.m
 *  XCMultiTableDemo
 *
 * Created by Kingiol on 2013-07-19.
 * Copyright (c) 2013 Kingiol Ding. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
#import "SortableTableViewController.h"
#import "XCMultiSortTableView.h"
#import "Configs.h"
#import "ProgressHUD.h"

#import <Parse/Parse.h>

@interface SortableTableViewController () <XCMultiTableViewDataSource>
{
    NSMutableArray *yourStats;
}

@end

@implementation SortableTableViewController {
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize arrays
    yourStats = [[NSMutableArray alloc] init];
    [self initData];
    [self loadParse];
    NSLog(@"Your Stats: %@",yourStats);
    NSLog(@"Your Stats Count: %lu",(unsigned long)yourStats.count);
    
//    [self initData];
  
//    tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
//    tableView.leftHeaderEnable = YES;
//    tableView.datasource = self;
//    [self.view addSubview:tableView];
    
}

- (void)initData {
    //Samrat
    headData =[[NSMutableArray alloc] initWithObjects:@"type",@"seasonid",@"win",@"yourscore",@"oponentscore",@"twoptmade",@"twoattempted",@"threeptmade",@"threeptattempted",@"freethrowmade",@"freethrowattempted",@"assists",@"totalrebounds",@"defrebounds",@"offrebounds",@"steals",@"blocks",@"turnovers",@"gamewinner",@"scoringstyle",@"teamsize",@"fullcourt",nil];
    
    leftTableData=[[NSMutableArray alloc] init];
    rightTableData = [[NSMutableArray alloc] init];
    //
//    headData = [NSMutableArray arrayWithCapacity:10];
//    [headData addObject:@"one"];
//    [headData addObject:@"Two"];
//    [headData addObject:@"Three"];
//    [headData addObject:@"Four"];
//    [headData addObject:@"Five"];
    
//    leftTableData = [NSMutableArray arrayWithCapacity:10];
//    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 0; i < 3; i++) {
//        [one addObject:[NSString stringWithFormat:@"Let's See - %d", i]];
//    }
//    [leftTableData addObject:one];
//    NSMutableArray *two = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 3; i < 10; i++) {
//        [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
//    }
//    [leftTableData addObject:two];
//    rightTableData = [NSMutableArray arrayWithCapacity:10];
//    
//    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 0; i < 3; i++) {
//        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
//        for (int j = 0; j < 5; j++) {
//            if (j == 1) {
////                [ary addObject:[NSNumber numberWithInt:random() % 5]];
//                 [ary addObject:[NSNumber numberWithInt:2]];
//            }else if (j == 2) {
////                [ary addObject:[NSNumber numberWithInt:random() % 10]];
//                [ary addObject:[NSNumber numberWithInt:3]];
//            }
//            else {
//                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
//            }
//        }
//        [oneR addObject:ary];
//    }
//    [rightTableData addObject:oneR];
//    
//    NSMutableArray *twoR = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 3; i < 10; i++) {
//        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
//        for (int j = 0; j < 5; j++) {
//            if (j == 1) {
////                [ary addObject:[NSNumber numberWithInt:random() % 5]];
//                [ary addObject:[NSNumber numberWithInt:1]];
//            }else if (j == 2) {
////                [ary addObject:[NSNumber numberWithInt:random() % 5]];
//                [ary addObject:[NSNumber numberWithInt:4]];
//            }else {
//                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
//            }
//        }
//        [twoR addObject:ary];
//    }
//    [rightTableData addObject:twoR];
    
    /*
    NSLog(@"%@",oneR);
    NSLog(@"%@",twoR);
    NSLog(@"%@",one);
    NSLog(@"%@",two);
    NSLog(@"%@",leftTableData);
    NSLog(@"%@",rightTableData);
    NSLog(@"%@",headData);
     */
}

- (void)loadParse {
    if ([PFUser currentUser] != nil) {
        [self AddLoadingView];
        PFQuery *query = [PFQuery queryWithClassName:PF_GAME_CLASS_NAME];
        [query whereKey:PF_GAME_USER equalTo:[PFUser currentUser]];
        NSLog(@"Current User=%@ ",[PFUser currentUser]);
        NSLog(@"PF_GAME_USER =%@ ",PF_GAME_USER);
//        [query selectKeys:@[PF_GAME_TWOPTMADE, PF_GAME_TWOPTATTEMPTED]];
        //[query includeKey:PF_GAME_TWOPTMADE]; // this doesn't work
        [query orderByDescending:@"createdAt"];
        [query setLimit:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil) {
                 //[allObjects removeAllObjects];
                 [yourStats removeAllObjects];
                 [yourStats addObjectsFromArray:objects];
                 NSLog(@"All Object: %@",yourStats);
                 NSMutableArray *twoL=[[NSMutableArray alloc] init];
                 for (int j=0;j<[yourStats count]; j++) {
                      NSString *dateStr=[self dateToStringConvertion:[[yourStats objectAtIndex:j] valueForKey:@"createdAt"]];
                     [twoL addObject:dateStr];
                 }
//                 NSSortDescriptor *sortDescriptor= [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
//                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//                 NSArray *sortedArray = [twoL sortedArrayUsingDescriptors:sortDescriptors];
//                 NSLog(@"sortedArray=%@",sortedArray);
                 [leftTableData removeAllObjects];
                 [leftTableData addObject:twoL];
                 
                     NSMutableArray *twoR=[[NSMutableArray alloc] init];
                     for (int i=0;i<[yourStats count]; i++) {
                         NSMutableArray *ary = [[NSMutableArray alloc]init];
                         if ([[yourStats objectAtIndex:i] objectForKey:@"type"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"type"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"seasonid"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"seasonid"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"win"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"win"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"yourscore"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"yourscore"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"opponentscore"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"opponentscore"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"twoptmade"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"twoptmade"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"twoptattempted"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"twoptattempted"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"threeptmade"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"threeptmade"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"threeptattempted"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"threeptattempted"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"freethrowmade"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"freethrowmade"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"freethrowattempted"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"freethrowattempted"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"assists"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"assists"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"totalrebounds"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"totalrebounds"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"defrebounds"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"defrebounds"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"offrebounds"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"offrebounds"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"steals"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"steals"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"blocks"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"blocks"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"turnovers"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"turnovers"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"gamewinner"]) {
                              [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"gamewinner"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"scoringstyle"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"scoringstyle"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"teamsize"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"teamsize"]];
                         }else{
                             [ary addObject:@""];
                         }
                         if ([[yourStats objectAtIndex:i] objectForKey:@"fullcourt"]) {
                             [ary addObject:[[yourStats objectAtIndex:i] valueForKey:@"fullcourt"]];
                         }else{
                             [ary addObject:@""];
                         }
                         [twoR addObject:ary];
                     }
                 [rightTableData removeAllObjects];
                 [rightTableData addObject:twoR];
                 NSLog(@"left array=%@",leftTableData);
                 NSLog(@"right array=%@",rightTableData);
//
//                 //[_messagesTable reloadData];
//                 //[self updateEmptyView];
//                 //[self updateTabCounter];
//                 NSLog(@"All Object: %@",yourStats);
//                 NSLog(@"All Objects Count: %lu",(unsigned long)yourStats.count);
//                 
//                 for (NSObject *object in objects){
//                     NSString *sports = [object valueForKey:@"SportName"];
//                     NSLog(@"SportName =%@",sports);
//                   //[sportsArray addObject:sports];
//                 }
                 tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
                 tableView.leftHeaderEnable = YES;
                 tableView.datasource = self;
                 [self.view addSubview:tableView];
                  [self RemoveLoadingView];
             } else {
                 [self RemoveLoadingView];
                 [ProgressHUD showError:@"No Stats To Show"];
             }
         }];
    }
}

-(NSString *)dateToStringConvertion :(NSDate *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateString]];
    NSLog(@"%@", stringDate);
    
    return stringDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XCMultiTableViewDataSource


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    NSLog(@"Header = %@",[leftTableData objectAtIndex:section]);
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    NSLog(@"content = %@",[rightTableData objectAtIndex:section]);
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (AlignHorizontalPosition)tableView:(XCMultiTableView *)tableView inColumn:(NSInteger)column {
    return AlignHorizontalPositionCenter;
    //return AlignHorizontalPositionRight;
    //return AlignHorizontalPositionLeft;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    return 150.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
        return 35.0f;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    if (row % 2 == 0) {
        return [UIColor colorWithRed:115.0/255.0 green:153.0/255.0 blue:198.0/255.0 alpha:0.8];
    }
    return [UIColor colorWithRed:190.0/255.0 green:212.0/255.0 blue:233.0/255.0 alpha:0.8];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    return [UIColor blackColor];
}

- (IBAction)filter:(id)sender {
//    NSLog(@"Your Stats: %@",yourStats);
//    NSLog(@"Your Stats Count: %lu",(unsigned long)yourStats.count);
//    NSLog(@"Your Stats 1: %@",yourStats[1]);
}

#pragma mark-
#pragma mark Loading
-(void)AddLoadingView
{
    loadingBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 70)];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 10, 10);
    loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 20)];
    loadingText.font = [UIFont boldSystemFontOfSize:13];
    loadingText.center = CGPointMake(self.view.center.x + 20, self.view.center.y + 0);
    loadingBackground.layer.cornerRadius=10;
    loadingBackground.backgroundColor = [UIColor blackColor];
    loadingBackground.center = self.view.center;
    [indicator startAnimating];
    indicator.center = CGPointMake(self.view.center.x - 40, self.view.center.y + 0);
    loadingText.text = @"Loading...";
    loadingText.textColor = [UIColor whiteColor];
    loadingText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loadingBackground];
    [self.view addSubview:indicator];
    [self.view addSubview:loadingText];
    self.view.userInteractionEnabled=NO;
}

-(void)RemoveLoadingView
{
    [loadingBackground removeFromSuperview];
    [indicator removeFromSuperview];
    [loadingText removeFromSuperview];
    self.view.userInteractionEnabled=YES;
}

@end
