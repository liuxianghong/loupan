//
//  LPBranchNetworkTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPBranchNetworkTableViewCell.h"

@implementation LPBranchNetworkTableViewCell

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
    self.nameLabel.text = dic[@"branch_cname"];
    self.phoneLabel.text = dic[@"branch_tel"];
    self.emileLabel.text = dic[@"branch_email"];
}
@end
