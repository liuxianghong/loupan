//
//  LPDealRecordTableViewCell.h
//  loupan
//
//  Created by 刘向宏 on 15-4-1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPDealRecordTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UIImageView *stateImageView;
@property (nonatomic,weak) IBOutlet UILabel *bigLabel;
@property (nonatomic,weak) IBOutlet UILabel *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel *useAreaLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
-(void)setDataDic:(NSDictionary *)dic;
@end
