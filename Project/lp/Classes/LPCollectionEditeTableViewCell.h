//
//  LPCollectionEditeTableViewCell.h
//  loupan
//
//  Created by 刘向宏 on 15-4-3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPCollectionEditeTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *bigLabel;
@property (nonatomic,weak) IBOutlet UILabel *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel *useAreaLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;

@property (nonatomic ,weak) IBOutlet UIButton *deleteBtn;
-(void)setDataDic:(NSDictionary *)dic;
@end
