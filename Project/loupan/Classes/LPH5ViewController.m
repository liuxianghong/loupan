//
//  LPH5ViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPH5ViewController.h"

@interface LPH5ViewController ()
@property (nonatomic ,weak) IBOutlet UIWebView *webView;
@end

@implementation LPH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlString;
    NSString *titleString;
    switch (self.showType) {
        case 0:
        {
            urlString = @"http://property.mobile-apps.com.hk/realestate/h5_about_us.php";
            titleString = @"公司简介";
        }
            break;
        case 1:
        {
            urlString = @"http://property.mobile-apps.com.hk/realestate/h5_privacy_policy.php";
            titleString = @"私隐政策";
        }
            break;
        case 2:
        {
            urlString = @"http://property.mobile-apps.com.hk/realestate/h5_terms_service.php";
            titleString = @"服务条款";
        }
            break;
            
        default:
            break;
    }
    self.title = titleString;
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
