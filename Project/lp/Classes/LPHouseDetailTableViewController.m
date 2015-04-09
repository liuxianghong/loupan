//
//  LPHouseDetailTableViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPHouseDetailTableViewController.h"
#import "LPHouseButtomView.h"
#import "MBProgressHUD.h"
#import "LPImageLoopTableViewCell.h"

@interface LPHouseDetailTableViewController ()<UIScrollViewDelegate,LPHouseButtomViewDelegate>

@property (nonatomic ,weak) IBOutlet UILabel *labelbrief;

@property (nonatomic ,weak) IBOutlet UILabel *labelTitle1;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle2;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle3;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle4;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle5;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle6;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle7;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle8;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle9;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle10;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle11;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle12;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle13;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle14;
@property (nonatomic ,weak) IBOutlet UILabel *labelTitle15;

@property (nonatomic ,weak) IBOutlet UILabel *labelagentname;
@property (nonatomic ,weak) IBOutlet UILabel *labelagent_id;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentcompany;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentmobile;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentemail;

@property (nonatomic ,weak) IBOutlet UIImageView *agentImage;

@property (nonatomic ,weak) IBOutlet UILabel *labelagentname2;
@property (nonatomic ,weak) IBOutlet UILabel *labelagent_id2;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentcompany2;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentmobile2;
@property (nonatomic ,weak) IBOutlet UILabel *labelagentemail2;

@property (nonatomic ,weak) IBOutlet UIImageView *agentImage2;


@property (nonatomic ,weak) IBOutlet LPImageLoopTableViewCell *imageLoopCell;
@end

@implementation LPHouseDetailTableViewController
{
    LPHouseButtomView *buttomview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"%@",self.dataDic);
    
    //[self.imageLoopCell setImageUrlList:self.dataDic[@"images"]];
    
    self.labelbrief.text = self.dataDic[@"brief_cn"];
    
    self.labelTitle1.text = self.dataDic[@"title_cn"];
    self.labelTitle2.text = self.dataDic[@"price"];
    self.labelTitle3.text = self.dataDic[@"rent"];
    self.labelTitle4.text = self.dataDic[@"bulid_space"];
    self.labelTitle5.text = self.dataDic[@"use_space"];
    self.labelTitle6.text = self.dataDic[@"bulid_price"];
    self.labelTitle7.text = self.dataDic[@"use_price"];
    self.labelTitle8.text = self.dataDic[@"efficiency_ratio"];
    self.labelTitle9.text = self.dataDic[@"address_cn"];
    self.labelTitle10.text = self.dataDic[@"toward_cn"];
    self.labelTitle11.text = self.dataDic[@"house_age"] ;//stringValue];
    self.labelTitle12.text = self.dataDic[@"return_ratio"];
    self.labelTitle13.text = self.dataDic[@"detail_cn"];
    self.labelTitle14.text = self.dataDic[@"developers_cn"];
    self.labelTitle15.text = self.dataDic[@"nearby_school_cn"];
    
    
    NSArray *agentArray = self.dataDic[@"agent"];
    for (int i=0; i<[agentArray count]; i++) {
        if (i==0) {
            NSDictionary *dic = [agentArray objectAtIndex:0];
            
            self.labelagentname.text = dic[@"name_cn"];
            self.labelagent_id.text = dic[@"agent_id"];
            self.labelagentcompany.text = dic[@"company_cn"];
            self.labelagentmobile.text = dic[@"mobile"];
            self.labelagentemail.text = dic[@"email"];
        }
        else
        {
            NSDictionary *dic = [agentArray objectAtIndex:1];
            
            self.labelagentname2.text = dic[@"name_cn"];
            self.labelagent_id2.text = dic[@"agent_id"];
            self.labelagentcompany2.text = dic[@"company_cn"];
            self.labelagentmobile2.text = dic[@"mobile"];
            self.labelagentemail2.text = dic[@"email"];
        }
    }
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil];
    buttomview = [nibView objectAtIndex:0];
    buttomview.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
    buttomview.backgroundColor = [UIColor clearColor];
    buttomview.delegate = self;
    [self.view addSubview:buttomview];
    [self.view bringSubviewToFront:buttomview];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.imageLoopCell setImageUrlList:self.dataDic[@"images"]];
    [super viewDidAppear:animated];
    buttomview.frame = CGRectMake(0, self.tableView.contentOffset.y+self.tableView.height-50, self.view.width, 50);
    [self.view bringSubviewToFront:buttomview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    buttomview.frame = CGRectMake(0, scrollView.contentOffset.y+scrollView.height-50, self.view.width, 50);
    [self.view bringSubviewToFront:buttomview];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)DoCollection
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *collectionArray = [userDefaultes arrayForKey:@"collectionArray"];
    NSMutableArray *strArray = [[NSMutableArray alloc]initWithArray:collectionArray];
    for (NSString* str in collectionArray) {
        if ([str isEqualToString:self.dataDic[@"id"]]) {
            [self showHud];
            return;
        }
    }
    [strArray addObject:self.dataDic[@"id"]];
    [userDefaultes setValue:strArray forKey:@"collectionArray"];
    [userDefaultes synchronize];
    [self showHud];
}

- (void)DoShar
{}

- (void)DoCall
{}


-(void)showHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"已收藏";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5f];
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == [tableView numberOfSections]-1)
        return 50;
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSArray *array = self.dataDic[@"agent"];
    return 3+([array count]>1?2:[array count]);
}
//

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
