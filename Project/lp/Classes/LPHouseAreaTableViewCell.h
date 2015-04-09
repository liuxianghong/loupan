//
//  LPHouseAreaTableViewCell.h
//  loupan
//
//  Created by 刘向宏 on 15-3-31.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPHouseAreaTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *bigLabel;
@property (nonatomic,weak) IBOutlet UILabel *smallLabel;
-(void)setDataDic:(NSDictionary *)dic;
@end
