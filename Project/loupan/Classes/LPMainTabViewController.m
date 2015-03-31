//
//  LPMainTabViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-3-25.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPMainTabViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LPMainTabViewController ()

@end

@implementation LPMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance]setTintColor:UIColorFromRGB(0x000000)];
    
    for (UITabBarItem *item in self.tabBar.items) {
        int index = (int)[self.tabBar.items indexOfObject:item];
        UIImage *unselect = [UIImage imageNamed:[NSString stringWithFormat:@"Tab_%d", (index + 1)]];
        UIImage *select = [UIImage imageNamed:[NSString stringWithFormat:@"Tab_%dC", (index + 1)]];
        [item setImage:[unselect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
