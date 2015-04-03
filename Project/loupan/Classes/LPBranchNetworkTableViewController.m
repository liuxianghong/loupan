//
//  LPBranchNetworkTableViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPBranchNetworkTableViewController.h"
#import "LPBranchNetworkTableViewCell.h"
#import "LPMobileRequest.h"
#import "LPBranchDetailTableViewController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface LPBranchNetworkTableViewController ()
@property (nonatomic) NSInteger pages;
@property (nonatomic,strong) NSMutableArray *tableViewArray;
@end

@implementation LPBranchNetworkTableViewController
{
   
    NSInteger indexNext;
    NSInteger currentIndexRow;
    
    BOOL isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    isFirst = YES;
    self.pages = 1;
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        sself.pages = 1;
        [sself readDataList];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself loadMore];
    }];
    self.tableViewArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isFirst) {
        [self readDataList];
        isFirst = NO;
    }
}

-(void)loadMore
{
    if (indexNext == 0) {
        if (self.view.window) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.labelText = @"已到最后";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.5];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
        });
    }
    else
    {
        self.pages++;
        [self readDataList];
    }
}

-(void)readDataList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    NSDictionary *dic = @{
                          @"page" : @(self.pages),
                          @"rows" : @10
                          };
    [LPMobileRequest branch_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"data"];
        if (self.pages==1) {
            [self.tableViewArray removeAllObjects];
        }
        [self.tableViewArray addObjectsFromArray:array];
        NSDictionary *pagesDic = responseObject[@"pages"];
        indexNext = [pagesDic[@"next"] integerValue];
        [self.tableView reloadData];
        [hud hide:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.tableViewArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPBranchNetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"branchNetworkCell" forIndexPath:indexPath];
    [cell setDataDic:[self.tableViewArray objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    currentIndexRow = indexPath.row;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"branchDetailIdentifier"])
    {
        LPBranchDetailTableViewController *vc = segue.destinationViewController;
        vc.dataDic = [self.tableViewArray objectAtIndex:currentIndexRow];
    }
}


@end
