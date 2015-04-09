//
//  LPBranchNetworkTableViewCell.h
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBranchNetworkTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic,weak) IBOutlet UILabel *emileLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
-(void)setDataDic:(NSDictionary *)dic;
@end
