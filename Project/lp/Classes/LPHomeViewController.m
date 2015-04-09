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
#import "LPBuyingConditionsViewController.h"
#import "UIImageView+WebCache.h"

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
    NSInteger ScrollCount;
    NSArray *rollDataArray;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    
    NSInteger cellSelectRow;
    
    BOOL isfirst;
    
    UIImageView *barImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    NSDictionary *dic = @{
//                          @"name" : @"123",
//                          @"email" : @"123",
//                          @"mobile" : @"123",
//                          @"type" : @1,
//                          @"region_name" : @"123",
//                          @"district" : @"123",
//                          @"reamrk" : @"123",
//                          @"signature" : @"123",
//                          };
//    [LPMobileRequest houseAddWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        ;
//    }];
    cellDataArray = @[@[@"Home08",@"卖盘"],@[@"Home09",@"租盘"],@[@"Home10",@"放盘"],@[@"Home07",@"成交记录"]];
    
    [LPMobileRequest head_image_apiWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [responseObject[@"data"] firstObject];
        NSString *headString = dic[@"url"];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[headString stringToImageUrl]] placeholderImage:[UIImage imageNamed:@"houseDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                [self.headImageView setImage:[UIImage imageNamed:@"brokenImage"]];
            }
            [self.tableView reloadData];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.headImageView setImage:[UIImage imageNamed:@"brokenImage"]];
        [self.tableView reloadData];
    }];
    
    
    [LPMobileRequest roll_image_apiWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        rollDataArray = responseObject[@"data"];
        ScrollCount = [rollDataArray count];
        ScrollViewIndex = 0;
        [self updateScrollImages];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    ScrollCount = 0;
    ScrollViewIndex = 0;
    [self updateScrollImages];
    self.scrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    [self.scrollView addGestureRecognizer:tap];
    isfirst = YES;
    
    barImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Home21"]];
    [barImageView sizeToFit];
    barImageView.top = 10;
    barImageView.left = 15;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Home01"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar addSubview:barImageView];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if (isfirst) {
        [self loadScrollViewSubViews];
        isfirst = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"MortgageCalculate01"] forBarMetrics:UIBarMetricsDefault];
    [barImageView removeFromSuperview];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark TapEvent

- (void)tapEvent
{
    NSString *str = [rollDataArray objectAtIndex:[self getImageIndex:(ScrollViewIndex)]][@"response_url"];
    NSLog(@"%@",str);
    NSURL *url = [[NSURL alloc]initWithString:str];
    [[UIApplication sharedApplication]openURL:url];
//    NSString * strMsg = [NSString stringWithFormat:@"当前图片理论计数:%i",ScrollViewIndex];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片计数" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

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
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"houseDefault"]];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"houseDefault"]];
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"houseDefault"]];
    
    
    
    [self.scrollView addSubview:imageView1];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
}

- (void)nextImageViewWithImage
{
    ScrollViewIndex ++;
    if (ScrollViewIndex>(ScrollCount-1)) {
        ScrollViewIndex = 0;
    }
    [self updateScrollImages];
}

- (void)previousImageViewWithImage
{
    ScrollViewIndex --;
    if (ScrollViewIndex<0) {
        ScrollViewIndex = ScrollCount-1;
    }
    [self updateScrollImages];
}

-(NSInteger)getImageIndex:(NSInteger)index
{
    if (ScrollCount==0) {
        return 0;
    }
    if (index<0) {
        return ScrollCount-1;
    }
    if (index>(ScrollCount-1)) {
        return index%ScrollCount;
    }
    return index;
}

-(void)updateScrollImages
{
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[[rollDataArray objectAtIndex:[self getImageIndex:(ScrollViewIndex-1)]][@"url"] stringToImageUrl]]];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:[[rollDataArray objectAtIndex:[self getImageIndex:ScrollViewIndex]][@"url"] stringToImageUrl]]];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:[[rollDataArray objectAtIndex:[self getImageIndex:(ScrollViewIndex+1)]][@"url"] stringToImageUrl]]];
    self.pageControl.numberOfPages = ScrollCount;
    self.pageControl.currentPage = ScrollViewIndex;
}

-(IBAction)leftScrollClick:(id)sender
{
    if (ScrollCount<2) {
        return;
    }
    [self previousImageViewWithImage];
}

-(IBAction)rightScrollClick:(id)sender
{
    if (ScrollCount<2) {
        return;
    }
    [self nextImageViewWithImage];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellSelectRow = indexPath.row;
    if (cellSelectRow<2) {
        [self performSegueWithIdentifier:@"homeBuyIdentifier" sender:nil];
    }
    else if (cellSelectRow==2) {
        [self performSegueWithIdentifier:@"plateIdentifier" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"dealRecord" sender:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"homeBuyIdentifier"]) {
        LPBuyingConditionsViewController *vc = segue.destinationViewController;
        vc.category = cellSelectRow + 1;
    }
}


@end
