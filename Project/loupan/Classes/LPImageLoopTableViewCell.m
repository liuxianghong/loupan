//
//  LPImageLoopTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPImageLoopTableViewCell.h"

@implementation LPImageLoopTableViewCell
{
    NSInteger ScrollViewIndex;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
}

- (void)awakeFromNib {
    // Initialization code
    [self loadScrollViewSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*3, self.scrollView.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
    [imageView1 setFrame:CGRectMake(          0, 0, self.scrollView.width, self.scrollView.height)];
    [imageView2 setFrame:CGRectMake(  self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [imageView3 setFrame:CGRectMake(2*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
}
#pragma mark UIScrollView
//----------------------------------------------------------------------------------------------翻页到临界值，回到scrollView中间
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    if (scrollView.contentOffset.x <= 0) {
        [self previousImageViewWithImage];
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    }
    if (scrollView.contentOffset.x >= 2*scrollView.width) {
        [self nextImageViewWithImage];
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    }
    
}

//----------------------------------------------------------------------------------------------加速度停止后，回到中间，带动画效果
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:YES];
}

- (void)loadScrollViewSubViews
{
    [self.scrollView setPagingEnabled:YES];
    
    //----------------------------------------------------------------------------------------------为了显示效果，去掉进度条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    
    
    
    [self.scrollView addSubview:imageView1];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
}

- (void)nextImageViewWithImage
{
    ScrollViewIndex ++;
    if (ScrollViewIndex>4) {
        ScrollViewIndex = 0;
    }
}

- (void)previousImageViewWithImage
{
    ScrollViewIndex --;
    if (ScrollViewIndex<0) {
        ScrollViewIndex = 4;
    }
}

-(IBAction)leftScrollClick:(id)sender
{
}

-(IBAction)rightScrollClick:(id)sender
{
}
@end
