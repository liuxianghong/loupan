//
//  LPDealRecordTableViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPDealRecordTableViewController.h"
#import "LPDealRecordTableViewCell.h"
#import "LPHouseSearchTableViewCell.h"
#import "LPMobileRequest.h"
#import <MBProgressHUD.h>
#import "LPDealDetailViewController.h"
#import <MJRefresh.h>

@interface LPDealRecordSearchModel : NSObject
@property (nonatomic,strong) NSString *district_code;
@property (nonatomic,strong) NSNumber *caler;
@end

@implementation LPDealRecordSearchModel
@end

@interface LPDealRecordTableViewController ()
@property (nonatomic ,weak) IBOutlet UITableView *tableView;
@property (nonatomic ,weak) IBOutlet UIButton *btn1;
@property (nonatomic ,weak) IBOutlet UIButton *btn2;
@property (nonatomic) NSInteger pages;
@property (nonatomic, strong) LPDealRecordSearchModel *searchModel;
@end

@implementation LPDealRecordTableViewController
{
    NSArray *tableViewArray;
    BOOL isFirst;
    NSInteger cellSelectRow;
    NSInteger indexNext;
    
    NSInteger index;
    
    NSArray *searchAreaArray;
    NSArray *searchCalerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    isFirst = YES;
    //self.tableView.backgroundColor = self.view.backgroundColor;
    
    CGRect tableviewfootrect = self.tableView.tableHeaderView.frame;
    tableviewfootrect.size.height = 1;
    [self.tableView.tableHeaderView setFrame:tableviewfootrect];
    
    isFirst = YES;
    self.pages = 1;
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refresh];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself loadMore];
    }];
    
    index = 0;
    searchCalerArray = @[@"售",@"租"];
    self.searchModel = [[LPDealRecordSearchModel alloc]init];
    [LPUiStyle btnSearchStyle:self.btn1];
    [LPUiStyle btnSearchStyle:self.btn2];
    
    [self getAreaList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    if(index!=0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
        return;
    }
    self.pages = 1;
    [self readDataList];
}

-(void)getAreaList
{
    [LPMobileRequest area_apiWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        searchAreaArray = responseObject[@"data"];
        if (index==1) {
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
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
    if(index!=0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
        return;
    }
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    NSDictionary *dic = @{
                          @"page" : @(self.pages),
                          @"rows" : @10
                          };
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (self.searchModel.district_code) {
        [mdic setObject:self.searchModel.district_code forKey:@"district_code"];
    }
    if (self.searchModel.caler) {
        [mdic setObject:self.searchModel.caler forKey:@"category"];
    }
    [LPMobileRequest house_trade_apiWithParameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        tableViewArray = nil;
        [self.tableView reloadData];
        hud.labelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    }];
}

-(void)getTableViewDataByDic:(NSDictionary *)dic
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [LPMobileRequest house_trade_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tableViewArray = responseObject[@"data"];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    }];
}

-(IBAction)leftButtonClicked:(id)sender
{
    index = 1;
    [self.tableView reloadData];
}

-(IBAction)rightButtonClicked:(id)sender
{
    index = 2;
    [self.tableView reloadData];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (index!=0) {
        return 45;
    }
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
    if (index==1) {
        return [searchAreaArray count];
    }
    else if(index==2)
    {
        return [searchCalerArray count];
    }
    else
        return [tableViewArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (index==0) {
        cellSelectRow = indexPath.row;
        [self performSegueWithIdentifier:@"goidentifier" sender:nil];
    }
    else
    {
        if (index==1) {
            NSDictionary *dic = [searchAreaArray objectAtIndex:indexPath.row];
            self.searchModel.district_code = dic[@"code"];
        }
        else
        {
            self.searchModel.caler = [NSNumber numberWithInteger:(indexPath.row+1)];
        }
        index = 0;
        [self refresh];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (index==0) {
        LPDealRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealRecordcell" forIndexPath:indexPath];
        
        [cell setDataDic:[tableViewArray objectAtIndex:indexPath.row]];
        // Configure the cell...
        
        return cell;
    }
    else
    {
        LPHouseSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serachCell" forIndexPath:indexPath];
        switch (index) {
            case 1:
            {
                NSDictionary *dic = [searchAreaArray objectAtIndex:indexPath.row];
                cell.nameLabel.text = dic[@"district_cname"];
                if ([self.searchModel.district_code isEqualToString:dic[@"code"]]) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@   √",dic[@"district_cname"]] ;
                    cell.nameLabel.textColor = [UIColor blackColor];
                }
                else
                {
                    cell.nameLabel.text = dic[@"district_cname"];
                    cell.nameLabel.textColor = [UIColor darkGrayColor];
                }
            }
                break;
            case 2:
            {
                NSString *str = [searchCalerArray objectAtIndex:indexPath.row];
                
                if ([self.searchModel.caler integerValue]==(indexPath.row+1)) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@   √",str] ;
                    cell.nameLabel.textColor = [UIColor blackColor];
                }
                else
                {
                    cell.nameLabel.text = str;
                    cell.nameLabel.textColor = [UIColor darkGrayColor];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
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
    //goidentifier
    if ([segue.identifier isEqualToString:@"goidentifier"]) {
        LPDealDetailViewController *vc = segue.destinationViewController;
        vc.code = [tableViewArray objectAtIndex:cellSelectRow][@"region_code"];
    }
}


@end
