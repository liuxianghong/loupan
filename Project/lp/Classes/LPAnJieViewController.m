//
//  LPAnJieViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPAnJieViewController.h"

@interface LPAnJieViewController ()
@property (nonatomic ,weak) IBOutlet UIButton *btn1;
@property (nonatomic ,weak) IBOutlet UIButton *btn2;

@property (nonatomic ,weak) IBOutlet UIView *viewBack;
@property (nonatomic ,weak) IBOutlet UIWebView *webView;
@end

@implementation LPAnJieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.hidden = YES;
    [LPUiStyle btnTabSelect:self.btn1];
    [LPUiStyle btnTabUnselect:self.btn2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)leftClicked:(id)sender
{
    [LPUiStyle btnTabSelect:self.btn1];
    [LPUiStyle btnTabUnselect:self.btn2];
    self.webView.hidden = YES;
}

-(IBAction)rightClicked:(id)sender
{
    [LPUiStyle btnTabSelect:self.btn2];
    [LPUiStyle btnTabUnselect:self.btn1];
    self.webView.hidden = NO;
    NSString *urlString = @"http://property.mobile-apps.com.hk/realestate/h5_mortgage_rate.php";
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
