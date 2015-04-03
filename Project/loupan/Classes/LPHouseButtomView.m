//
//  LPHouseButtomView.m
//  loupan
//
//  Created by 刘向宏 on 15-4-2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPHouseButtomView.h"

@implementation LPHouseButtomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
    }
    return self;
}

-(IBAction)collectionClicked:(id)sender
{
    NSLog(@"collectionClicked");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(DoCollection)]) {
        [self.delegate DoCollection];
    }
}

-(IBAction)callClicked:(id)sender
{
    NSLog(@"callClicked");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(DoCall)]) {
        [self.delegate DoCall];
    }
}

-(IBAction)shareClicked:(id)sender
{
    NSLog(@"shareClicked");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(DoShar)]) {
        [self.delegate DoShar];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.button1.imageView setContentMode:UIViewContentModeCenter];
    [self.button1 setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                             0.0,
                                             0.0,
                                             -14)];
    [self.button1.titleLabel setContentMode:UIViewContentModeCenter];
    [self.button1 setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                             -self.button1.imageView.image.size.width/2,
                                             0.0,
                                             0.0)];
    
    [self.button2.imageView setContentMode:UIViewContentModeCenter];
    [self.button2 setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                             0.0,
                                             0.0,
                                             -17)];
    [self.button2.titleLabel setContentMode:UIViewContentModeCenter];
    [self.button2 setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                             -self.button2.imageView.image.size.width-3,
                                             0.0,
                                             0.0)];
    
    [self.button3.imageView setContentMode:UIViewContentModeCenter];
    [self.button3 setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                             0.0,
                                             0.0,
                                             -14)];
    [self.button3.titleLabel setContentMode:UIViewContentModeCenter];
    [self.button3 setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                             -self.button3.imageView.image.size.width/2,
                                             0.0,
                                             0.0)];
}

@end
