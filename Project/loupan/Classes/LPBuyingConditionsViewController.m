//
//  LPBuyingConditionsViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPBuyingConditionsViewController.h"

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
@end

@implementation LPBuyingConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
