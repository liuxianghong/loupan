//
//  LPCollectionTableViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPCollectionTableViewController.h"
#import "LPHouseInformationTableViewCell.h"
#import "LPMobileRequest.h"
#import <MBProgressHUD.h>
#import "LPHouseDetailTableViewController.h"
#import <MJRefresh.h>

@interface LPCollectionTableViewController ()
@property (nonatomic) NSInteger pages;
@end

@implementation LPCollectionTableViewController
{
    BOOL isFirst;
    NSArray *tableViewArray;
    NSInteger indexNext;
    NSInteger cellSelect;
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
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isFirst) {
        isFirst = NO;
        [self readDataList];
    }
}

-(void)loadMore
{
    if (indexNext == 0) {
        if (self.view.window) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *collectionArray = [userDefaultes arrayForKey:@"collectionArray"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    if ([collectionArray count]<1) {
        hud.labelText = @"暂无收藏";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        return;
    }
    NSString *dis = [[NSString alloc]init];
    for (int i=0 ; i< [collectionArray count]; i++) {
        NSString *str = [collectionArray objectAtIndex:i];
        dis = [dis stringByAppendingString:str];
        if (i!=([collectionArray count]-1)) {
            dis = [dis stringByAppendingString:@","];
        }
    }
    NSDictionary *dic = @{
                          @"ids" : dis,
                          @"page" : @(self.pages),
                          @"rows" : @10
                          };
    NSLog(@"%@",dic);
    [LPMobileRequest collection_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"data"];
        if (self.pages==1) {
            tableViewArray = [array copy];
        }
        else
        {
            NSMutableArray *copyArray = [NSMutableArray arrayWithArray:tableViewArray];
            [copyArray addObjectsFromArray:array];
            tableViewArray = copyArray;
        }
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tableViewArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    cellSelect = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHouseInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInformationcell" forIndexPath:indexPath];
    [cell setDataDic:[tableViewArray objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
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
    //houseDetail
    if([segue.identifier isEqualToString:@"houseDetail"])
    {
        LPHouseDetailTableViewController *vc = segue.destinationViewController;
        vc.dataDic = [tableViewArray objectAtIndex:cellSelect];
    }
}


@end
