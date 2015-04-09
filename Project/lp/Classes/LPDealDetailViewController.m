//
//  LPDealDetailViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPDealDetailViewController.h"
#import "LPHouseInformationTableViewCell.h"
#import "LPMobileRequest.h"
#import "MBProgressHUD.h"
#import "LPHouseDetailTableViewController.h"
#import "MJRefresh.h"

@interface LPDealDetailViewController ()
@property (nonatomic ,weak) IBOutlet UITableView *tableView;
@property (nonatomic ,weak) IBOutlet UIButton *btn1;
@property (nonatomic ,weak) IBOutlet UIButton *btn2;
@property (nonatomic) NSInteger pages;
@end

@implementation LPDealDetailViewController
{
    NSArray *tableViewArray;
    BOOL isFirst;
    NSInteger cellSelectRow;
    NSInteger indexNext;
    NSInteger category;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    category = 1;
    isFirst = YES;
    self.pages = 1;
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        sself.pages = 1;
        [sself getHouseListByArea];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself loadMore];
    }];
    
    [LPUiStyle btnTabSelect:self.btn1];
    [LPUiStyle btnTabUnselect:self.btn2];
    
    if (self.cname) {
        self.title = self.cname;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)leftCliced:(id)sender
{
    category = 1;
    self.pages = 1;
    [LPUiStyle btnTabSelect:self.btn1];
    [LPUiStyle btnTabUnselect:self.btn2];
    [self getHouseListByArea];
}

-(IBAction)rightCliced:(id)sender
{
    category = 2;
    self.pages = 1;
    [LPUiStyle btnTabSelect:self.btn2];
    [LPUiStyle btnTabUnselect:self.btn1];
    [self getHouseListByArea];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isFirst) {
        [self getHouseListByArea];
        isFirst = NO;
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
        [self getHouseListByArea];
    }
}

-(void)getHouseListByArea
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@(category) forKey:@"category"];
    [dic setObject:@(self.pages) forKey:@"page"];
    [dic setObject:@(10) forKey:@"rows"];
    NSString *md5Str = [[NSString alloc]init];
    md5Str = [md5Str stringByAppendingString:self.code];
    [dic setObject:self.code forKey:@"region_code"];
    md5Str = [NSString stringWithFormat:@"%@%ld",md5Str,category];
    [dic setObject:[md5Str stringFromMD5] forKey:@"signature"];
    [self getHouseList:dic];
}

-(void)getHouseList:(NSDictionary *)dic
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [LPMobileRequest house_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
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
        indexNext = [responseObject[@"pages"][@"next"] integerValue];
        [self.tableView reloadData];
        [hud hide:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    }];
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
    cellSelectRow = indexPath.row;
    //[self performSegueWithIdentifier:@"goidentifier" sender:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHouseInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInformationcell" forIndexPath:indexPath];
    [cell setDataDic:[tableViewArray objectAtIndex:indexPath.row]];
    // Configure the cell...
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //goidentifier
    if ([segue.identifier isEqualToString:@"HouseDetail"]) {
        LPHouseDetailTableViewController *vc = segue.destinationViewController;
        vc.dataDic = [tableViewArray objectAtIndex:cellSelectRow];
    }
}


@end
