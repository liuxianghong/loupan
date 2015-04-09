//
//  LPHomeTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-3-26.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPHomeTableViewCell.h"

@implementation LPHomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Home06"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
