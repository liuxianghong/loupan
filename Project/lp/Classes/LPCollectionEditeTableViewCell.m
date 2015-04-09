//
//  LPCollectionEditeTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-4-3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPCollectionEditeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation LPCollectionEditeTableViewCell

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
    self.bigLabel.text = dic[@"title_cn"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@万",dic[@"price"]];
    self.areaLabel.text = [NSString stringWithFormat:@"%@尺（$%@/尺）",dic[@"bulid_space"],dic[@"bulid_price"]] ;
    self.useAreaLabel.text = [NSString stringWithFormat:@"%@尺（$%@/尺）",dic[@"use_space"],dic[@"use_price"]] ;
    
    NSString *iconStr = [dic[@"listimage"] stringToImageUrl];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"houseDefault"]];
}
@end
