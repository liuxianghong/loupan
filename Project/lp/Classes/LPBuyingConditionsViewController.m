//
//  LPBuyingConditionsViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LPBuyingConditionsViewController.h"
#import "LPHouseInformationTableViewCell.h"
#import "LPHouseAreaTableViewCell.h"
#import "LPHouseSearchTableViewCell.h"
#import "LPMobileRequest.h"
#import "LPHouseDetailTableViewController.h"
#import "LPDealDetailViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface LPBuyingConditionsSearchModel : NSObject
@property (nonatomic,strong) NSString *region_code;
@property (nonatomic,strong) NSString *district_code;
@property (nonatomic,strong) NSString *space_code;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *price;
@end

@implementation LPBuyingConditionsSearchModel
@end

@interface LPBuyingConditionsViewController ()
@property (nonatomic,weak) IBOutlet UIView *serachView;
@property (nonatomic,weak) IBOutlet UIButton *indexButtonArea;
@property (nonatomic,weak) IBOutlet UIButton *indexButtonMap;
@property (nonatomic,weak) IBOutlet UIButton *indexButtonHouse;
@property (nonatomic,weak) IBOutlet UIView *contextView;
@property (nonatomic,weak) IBOutlet UIButton *serachButton1;
@property (nonatomic,weak) IBOutlet UIButton *serachButton2;
@property (nonatomic,weak) IBOutlet UIButton *serachButton3;
@property (nonatomic,weak) IBOutlet UIButton *serachButton4;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) LPBuyingConditionsSearchModel *searchModel;

@property (nonatomic) NSInteger regionPages;
@property (nonatomic) NSInteger searchPages;
@end

@implementation LPBuyingConditionsViewController
{
    NSArray *containsArray;
    
    NSArray *searchTableViewArray;
    NSArray *searchAreaArray;
    NSArray *searchSpaceArray;
    
    NSArray *regionTableViewArray;
    NSArray *regionSubTableViewArray;
    
    NSInteger index;
    
    BOOL first;
    NSInteger firstCount;
    MBProgressHUD *firstHud;
    
    NSInteger next;
    NSInteger searchNext;
    NSInteger regionNext;
    
    NSDictionary *currentDic;
    
    NSString *goCode;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index = 0;
    first = YES;
    
    self.searchModel = [[LPBuyingConditionsSearchModel alloc] init];
    
    if (self.category == 1) {
        self.title = @"卖盘";
    }
    else
    {
        self.title = @"租盘";
    }
    
    [self.indexButtonArea setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.searchPages = 1;
    self.regionPages = 1;
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refresh];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself loadMore];
    }];
    [LPUiStyle btnTabSelect:self.indexButtonArea];
    [LPUiStyle btnTabUnselect:self.indexButtonMap];
    [LPUiStyle btnTabUnselect:self.indexButtonHouse];
    
    [LPUiStyle btnSearchStyle:self.serachButton1];
    [LPUiStyle btnSearchStyle:self.serachButton2];
    [LPUiStyle btnSearchStyle:self.serachButton3];
    [LPUiStyle btnSearchStyle:self.serachButton4];
}

-(void)refresh
{
    switch (index) {
        case 0:
        {
            self.searchPages = 1;
            [self reloadHouseList];
        }
            break;
        case 2:
        {
            self.regionPages = 1;
            [self getRegionArray];
        }
            break;
            
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.header endRefreshing];
            });
            return;
        }
            break;
    }
}

-(void)loadMore
{
    NSInteger indexNext = 0;
    switch (index) {
        case 0:
        {
            indexNext = searchNext;
        }
            break;
        case 2:
        {
            indexNext = regionNext;
        }
            break;
            
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.footer endRefreshing];
            });
            return;
        }
            break;
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
        switch (index) {
            case 0:
            {
                self.searchPages++;
                [self reloadHouseList];
            }
                break;
            case 2:
            {
                self.regionPages++;
                [self getRegionArray];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (first) {
        firstCount = 3;
        firstHud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        firstHud.labelText = @"加载数据中";
        NSString *md5String = [NSString stringWithFormat:@"%ld",(long)self.category];
        NSLog(@"%@",md5String);
        NSDictionary *dic = @{
                              @"category" : @(self.category),
                              @"page" : @1,
                              @"rows" : @10,
                              @"signature" : [md5String stringFromMD5]
                              };
        [self getHouseList:dic showHud:NO];
        [self getAreaList];
        [self getSpaceList];
        first = NO;
    }
}

//-(void)getHouseListByArea:(NSString *)code
//{
//    index = 7;
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:@(self.category) forKey:@"category"];
//    [dic setObject:@(1) forKey:@"page"];
//    [dic setObject:@(10) forKey:@"rows"];
//    NSString *md5Str = [[NSString alloc]init];
//    md5Str = [md5Str stringByAppendingString:code];
//    [dic setObject:code forKey:@"region_code"];
//    md5Str = [NSString stringWithFormat:@"%@%ld",md5Str,self.category];
//    [dic setObject:[md5Str stringFromMD5] forKey:@"signature"];
//    [self getHouseList:dic];
//}

-(void)reloadHouseList
{
    index = 0;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@(self.category) forKey:@"category"];
    [dic setObject:@(self.searchPages) forKey:@"page"];
    [dic setObject:@(10) forKey:@"rows"];
    NSString *md5Str = [[NSString alloc]init];
    if (self.searchModel.region_code) {
        md5Str = [md5Str stringByAppendingString:self.searchModel.region_code];
        [dic setObject:self.searchModel.region_code forKey:@"region_code"];
    }
    if (self.searchModel.district_code) {
        md5Str = [md5Str stringByAppendingString:self.searchModel.district_code];
        [dic setObject:self.searchModel.district_code forKey:@"district_code"];
    }
    if (self.searchModel.space_code) {
        md5Str = [md5Str stringByAppendingString:self.searchModel.space_code];
        [dic setObject:self.searchModel.space_code forKey:@"space_code"];
    }
    if (self.searchModel.area) {
        md5Str = [md5Str stringByAppendingString:self.searchModel.area];
        [dic setObject:self.searchModel.area forKey:@"area"];
    }
    if (self.searchModel.price) {
        md5Str = [md5Str stringByAppendingString:self.searchModel.price];
        [dic setObject:self.searchModel.price forKey:@"price"];
    }
    md5Str = [NSString stringWithFormat:@"%@%ld",md5Str,self.category];
    [dic setObject:[md5Str stringFromMD5] forKey:@"signature"];
    [self getHouseList:dic];
}

-(void)getHouseList:(NSDictionary *)dic
{
    [self getHouseList:dic showHud:YES];
}

-(void)getHouseList:(NSDictionary *)dic showHud:(BOOL)bo
{
    NSLog(@"%@",dic);
    MBProgressHUD *hud = nil;
    if(bo){
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    }
    [LPMobileRequest house_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        if(index == 7)
        {
            regionSubTableViewArray = responseObject[@"data"];
            next = [responseObject[@"pages"][@"next"] integerValue];
        }
        else
        {
            NSArray *array = responseObject[@"data"];
            if (self.searchPages==1) {
                searchTableViewArray = [array copy];
            }
            else
            {
                NSMutableArray *copyArray = [NSMutableArray arrayWithArray:searchTableViewArray];
                [copyArray addObjectsFromArray:array];
                searchTableViewArray = copyArray;
            }
            next = [responseObject[@"pages"][@"next"] integerValue];
        }
        [self.tableView reloadData];
        if(bo){
            [hud hide:YES];
        }
        else
        {
            firstCount--;
            if (firstCount==0) {
                [firstHud hide:YES];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(bo){
            hud.labelText = error.domain;
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.0f];
        }
        else
        {
            firstCount--;
            if (firstCount==0) {
                [firstHud hide:YES];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        });
    }];
}

-(void)getAreaList
{
    [LPMobileRequest area_apiWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        firstCount--;
        if (firstCount==0) {
            [firstHud hide:YES];
        }
        searchAreaArray = responseObject[@"data"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        firstCount--;
        if (firstCount==0) {
            [firstHud hide:YES];
        }
    }];
}

-(void)getSpaceList
{
    [LPMobileRequest space_apiWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        firstCount--;
        if (firstCount==0) {
            [firstHud hide:YES];
        }
        searchSpaceArray = responseObject[@"data"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        firstCount--;
        if (firstCount==0) {
            [firstHud hide:YES];
        }
    }];
}

-(void)getRegionArray
{
    NSDictionary *dic = @{
                          @"page" : @(self.regionPages),
                          @"rows" : @10
                          };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [LPMobileRequest region_apiWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"data"];
        if (self.regionPages==1) {
            regionTableViewArray = [array copy];
        }
        else
        {
            NSMutableArray *copyArray = [NSMutableArray arrayWithArray:regionTableViewArray];
            [copyArray addObjectsFromArray:array];
            regionTableViewArray = copyArray;
        }
        [hud hide:YES];
        [self.tableView reloadData];
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

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchButtonClicked:(UIButton *)sender
{
    index = 3+sender.tag;
    [self.tableView reloadData];
}

-(IBAction)indexButtonClicked:(UIButton *)sender
{
    [LPUiStyle btnTabUnselect:self.indexButtonArea];
    [LPUiStyle btnTabUnselect:self.indexButtonMap];
    [LPUiStyle btnTabUnselect:self.indexButtonHouse];
    [LPUiStyle btnTabSelect:sender];
    
    index = sender.tag;
    [self.serachView removeConstraints:containsArray];
    CGFloat height;
    switch (sender.tag) {
        case 0:
        {
            
            self.mapView.hidden = YES;
            self.tableView.hidden = NO;
            self.serachView.hidden = NO;
            height = 30;
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.mapView.hidden = NO;
            self.tableView.hidden = YES;
            self.serachView.hidden = YES;
            height = 0;
        }
            break;
        case 2:
        {
            self.mapView.hidden = YES;
            self.tableView.hidden = NO;
            height = 0;
            self.serachView.hidden = YES;
            [self.tableView reloadData];
            if(!regionTableViewArray)
            {
                [self getRegionArray];
            }
        }
            break;
            
        default:
            break;
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_serachView);
    containsArray = [[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_serachView(%f)]",height] options:0 metrics:0 views:views] copy];
    [self.serachView addConstraints:containsArray];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (index) {
        case 0:
        {
            currentDic = [searchTableViewArray objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"houseDetail" sender:nil];
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            NSDictionary *dic = [regionTableViewArray objectAtIndex:indexPath.row];
            goCode = dic[@"code"];
            [self performSegueWithIdentifier:@"goidentifier" sender:nil];
        }
            break;
        case 3:
        {
            self.searchPages = 1;
            NSDictionary *dic = [searchAreaArray objectAtIndex:indexPath.row];
            self.searchModel.district_code = dic[@"code"];
            [self reloadHouseList];
        }
            break;
        case 4:
        {
        }
            break;
        case 5:
        {
            self.searchPages = 1;
            NSDictionary *dic = [searchSpaceArray objectAtIndex:indexPath.row];
            self.searchModel.space_code = dic[@"code"];
            [self reloadHouseList];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            currentDic = [regionSubTableViewArray objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"houseDetail" sender:nil];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (index == 7) {
        return 85;
    }
    else if (index>2) {
        return 45;
    }
    else return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (index) {
        case 0:
        {
            return [searchTableViewArray count];
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            return [regionTableViewArray count];
        }
            break;
        case 3:
        {
            return [searchAreaArray count];
        }
            break;
        case 4:
        {
        }
            break;
        case 5:
        {
            return [searchSpaceArray count];
        }
            break;
        case 6:
        {
        }
            break;
        case 7:
        {
            return [regionSubTableViewArray count];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (index==0) {
        LPHouseInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInformationcell" forIndexPath:indexPath];
        NSDictionary *dic = [searchTableViewArray objectAtIndex:indexPath.row];
        [cell setDataDic:dic];
        return cell;
    }
    else if(index==2)
    {
        LPHouseAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseAreacell" forIndexPath:indexPath];
        NSDictionary *dic = [regionTableViewArray objectAtIndex:indexPath.row];
        [cell setDataDic:dic];
        return cell;
    }
    else if(index ==7)
    {
        LPHouseInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInformationcell" forIndexPath:indexPath];
        NSDictionary *dic = [regionSubTableViewArray objectAtIndex:indexPath.row];
        [cell setDataDic:dic];
        return cell;
    }
    else
    {
        LPHouseSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serachCell" forIndexPath:indexPath];
        switch (index) {
            case 3:
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
            case 5:
            {
                NSDictionary *dic = [searchSpaceArray objectAtIndex:indexPath.row];
                
                if ([self.searchModel.space_code isEqualToString:dic[@"code"]]) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@   √",dic[@"space_cname"]] ;
                    cell.nameLabel.textColor = [UIColor blackColor];
                }
                else
                {
                    cell.nameLabel.text = dic[@"space_cname"];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"houseDetail"]) {
        LPHouseDetailTableViewController *vc = segue.destinationViewController;
        vc.dataDic = currentDic;
    }
    else if ([segue.identifier isEqualToString:@"goidentifier"])
    {
        LPDealDetailViewController *vc = segue.destinationViewController;
        vc.code = goCode;
    }
}

@end
