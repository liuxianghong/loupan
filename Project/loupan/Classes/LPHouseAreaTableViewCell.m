//
//  LPHouseAreaTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-3-31.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPHouseAreaTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation LPHouseAreaTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Home06"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataDic:(NSDictionary *)dic
{
    self.bigLabel.text = dic[@"cname"];
    self.smallLabel.text = dic[@"address_cn"];
    
    NSString *iconStr = [dic[@"imageurl"] stringToImageUrl];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"houseDefault"]];
}
@end
