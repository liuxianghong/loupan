//
//  LPHomeViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-3-26.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPMobileRequest.h"
#import "LPHomeTableViewCell.h"

@interface LPHomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic ,strong) IBOutlet UIImageView *headImageView;
@end

@implementation LPHomeViewController
{
    NSArray *cellDataArray;
    NSInteger ScrollViewIndex;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSDictionary *dic = @{
                          @"name" : @"123",
                          @"email" : @"123",
                          @"mobile" : @"123",
                          @"type" : @1,
                          @"region_name" : @"123",
                          @"district" : @"123",
                          @"reamrk" : @"123",
                          @"signature" : @"123",
                          };
    [LPMobileRequest houseAddWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    cellDataArray = @[@[@"Home08",@"卖盘"],@[@"Home09",@"租盘"],@[@"Home10",@"放盘"],@[@"Home07",@"成交记录"]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self loadScrollViewSubViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*3, self.scrollView.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
    [imageView1 setFrame:CGRectMake(          0, 0, self.scrollView.width, self.scrollView.height)];
    [imageView2 setFrame:CGRectMake(  self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [imageView3 setFrame:CGRectMake(2*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollView
//----------------------------------------------------------------------------------------------翻页到临界值，回到scrollView中间
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    if (scrollView.contentOffset.x <= 0) {
        [self previousImageViewWithImage];
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    }
    if (scrollView.contentOffset.x >= 2*scrollView.width) {
        [self nextImageViewWithImage];
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    }
    
}

//----------------------------------------------------------------------------------------------加速度停止后，回到中间，带动画效果
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:YES];
}

- (void)loadScrollViewSubViews
{
    [self.scrollView setPagingEnabled:YES];
    
    //----------------------------------------------------------------------------------------------为了显示效果，去掉进度条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    
    
    
    [self.scrollView addSubview:imageView1];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
}

- (void)nextImageViewWithImage
{
    ScrollViewIndex ++;
    if (ScrollViewIndex>4) {
        ScrollViewIndex = 0;
    }
}

- (void)previousImageViewWithImage
{
    ScrollViewIndex --;
    if (ScrollViewIndex<0) {
        ScrollViewIndex = 4;
    }
}

-(IBAction)leftScrollClick:(id)sender
{
}

-(IBAction)rightScrollClick:(id)sender
{
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height/4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homecell" forIndexPath:indexPath];
    cell.dataImageView.image = [UIImage imageNamed:cellDataArray[indexPath.row][0]];
    cell.dataLabel.text = cellDataArray[indexPath.row][1];
    // Configure the cell...
    
    return cell;
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
