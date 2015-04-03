//
//  LPUiStyle.m
//  loupan
//
//  Created by 刘向宏 on 15-4-3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPUiStyle.h"

@implementation LPUiStyle
+(void)btnTabSelect:(UIButton *)btn
{
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 0.0f;
}
+(void)btnTabUnselect:(UIButton *)btn
{
    btn.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    btn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:216/255.0 blue:217/255.0 alpha:1.0f].CGColor;
    btn.layer.borderWidth = 1.0f;
}

+(void)btnSearchStyle:(UIButton *)btn
{
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:216/255.0 blue:217/255.0 alpha:1.0f].CGColor;
    btn.layer.borderWidth = 1.0f;
}
@end
