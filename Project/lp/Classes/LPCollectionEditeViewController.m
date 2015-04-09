//
//  LPCollectionEditeViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPCollectionEditeViewController.h"
#import "LPCollectionEditeTableViewCell.h"

@interface LPCollectionEditeViewController ()
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tableViewDataArray;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@end

@implementation LPCollectionEditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewDataArray = [[NSMutableArray alloc]initWithArray:self.tableViewArray];
    self.deleteArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)deleteClicked:(id)sender
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *collectionArray = [userDefaultes arrayForKey:@"collectionArray"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:collectionArray];
    for (NSDictionary *dic in self.deleteArray) {
        NSString *distr = dic[@"id"];
        for (NSString *str in collectionArray) {
            if ([distr isEqualToString:str]) {
                [array removeObject:str];
                break;
            }
        }
    }
    [userDefaultes setObject:array forKey:@"collectionArray"];
    [userDefaultes synchronize];
    [self.tableViewDataArray removeObjectsInArray:self.deleteArray];
    [self.tableView reloadData];
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
    return [self.tableViewDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPCollectionEditeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInformationcell" forIndexPath:indexPath];
    id dic = [self.tableViewDataArray objectAtIndex:indexPath.row];
    [cell setDataDic:dic];
    cell.deleteBtn.selected = [self.deleteArray containsObject:dic];
    // Configure the cell...
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    id dic = [self.tableViewDataArray objectAtIndex:btn.tag];
    if (btn.selected) {
        [self.deleteArray addObject:dic];
    }
    else
    {
        [self.deleteArray removeObject:dic];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
