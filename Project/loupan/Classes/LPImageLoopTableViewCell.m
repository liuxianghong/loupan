//
//  LPImageLoopTableViewCell.m
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPImageLoopTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface LPImageLoopTableViewCell ()<UIScrollViewDelegate>
@end

@implementation LPImageLoopTableViewCell
{
    NSInteger ScrollViewCount;
    NSInteger ScrollViewIndex;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    UIImageView * imageView4;
    UIImageView * imageView5;
    NSArray *imageUrlArray;
    
    CGFloat pagewith;
}

- (void)awakeFromNib {
    // Initialization code
    [self loadScrollViewSubViews];
    self.scrollView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutImageViews];
}

-(void)layoutImageViews
{
    if (ScrollViewCount == 0) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, self.scrollView.height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        imageView3.hidden = YES;
        imageView4.hidden = YES;
        imageView5.hidden = YES;
        self.pageControl.numberOfPages = ScrollViewCount;
        self.pageControl.currentPage = ScrollViewIndex;
        return;
    }
    pagewith = (self.scrollView.width-12)/2;
    if (ScrollViewCount<2) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, self.scrollView.height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        
        [imageView2 setFrame:CGRectMake(  2, 0, pagewith, self.scrollView.height)];;
        if ([imageUrlArray count]<1) {
            imageView2.hidden = YES;
        }
        else
        {
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:0] stringToImageUrl]]];
        }
        imageView3.hidden = YES;
        imageView1.hidden = YES;
        imageView4.hidden = YES;
        imageView5.hidden = YES;
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake(4*(pagewith+4)+pagewith, self.scrollView.height)];
        [self.scrollView setContentOffset:CGPointMake(pagewith, 0)];
        
        [imageView1 setFrame:CGRectMake(          0, 0, pagewith, self.scrollView.height)];
        [imageView2 setFrame:CGRectMake(  pagewith+4, 0, pagewith, self.scrollView.height)];
        [imageView3 setFrame:CGRectMake(2*(pagewith+4), 0, pagewith, self.scrollView.height)];
        [imageView4 setFrame:CGRectMake(3*(pagewith+4), 0, pagewith, self.scrollView.height)];
        [imageView5 setFrame:CGRectMake(4*(pagewith+4), 0, pagewith, self.scrollView.height)];
        [self updateImages];
    }
}

-(NSInteger)getImageIndex:(NSInteger)index
{
    if (index<0) {
        return ScrollViewCount-1;
    }
    if (index>(ScrollViewCount-1)) {
        return index%ScrollViewCount;
    }
    return index;
}

-(void)updateImages
{
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:[self getImageIndex:(ScrollViewIndex-1)]] stringToImageUrl]]];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:[self getImageIndex:ScrollViewIndex]] stringToImageUrl]]];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:[self getImageIndex:(ScrollViewIndex+1)]] stringToImageUrl]]];
    [imageView4 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:[self getImageIndex:(ScrollViewIndex+2)]] stringToImageUrl]]];
    [imageView5 sd_setImageWithURL:[NSURL URLWithString:[[imageUrlArray objectAtIndex:[self getImageIndex:(ScrollViewIndex+3)]] stringToImageUrl]]];
    self.pageControl.numberOfPages = ScrollViewCount;
    self.pageControl.currentPage = ScrollViewIndex;
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
        [scrollView setContentOffset:CGPointMake(pagewith, 0)];
    }
    if (scrollView.contentOffset.x >= 2*pagewith) {
        [self nextImageViewWithImage];
        [scrollView setContentOffset:CGPointMake(pagewith, 0)];
    }
}

//----------------------------------------------------------------------------------------------加速度停止后，回到中间，带动画效果
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    [scrollView setContentOffset:CGPointMake(pagewith, 0) animated:YES];
}

- (void)loadScrollViewSubViews
{
    [self.scrollView setPagingEnabled:YES];
    
    //----------------------------------------------------------------------------------------------为了显示效果，去掉进度条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.jpg"]];
    imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.jpg"]];
    
    [self.scrollView addSubview:imageView1];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
    [self.scrollView addSubview:imageView4];
    [self.scrollView addSubview:imageView5];
    
    imageView1.hidden = YES;
    imageView2.hidden = YES;
    imageView3.hidden = YES;
    imageView4.hidden = YES;
    imageView5.hidden = YES;
}

- (void)nextImageViewWithImage
{
    ScrollViewIndex ++;
    ScrollViewIndex = [self getImageIndex:ScrollViewIndex];
    [self updateImages];
}

- (void)previousImageViewWithImage
{
    ScrollViewIndex --;
    ScrollViewIndex = [self getImageIndex:ScrollViewIndex];
    [self updateImages];
}

-(IBAction)leftScrollClick:(id)sender
{
    if (ScrollViewCount<2) {
        return;
    }
    [self previousImageViewWithImage];
}

-(IBAction)rightScrollClick:(id)sender
{
    if (ScrollViewCount<2) {
        return;
    }
    [self nextImageViewWithImage];
}

-(void)setImageUrlList:(NSArray *)imageArray
{
    //imageArray = @[@"2.jpg",@"1.jpg",@"1.jpg"];
    imageView1.hidden = NO;
    imageView2.hidden = NO;
    imageView3.hidden = NO;
    imageView4.hidden = NO;
    imageView5.hidden = NO;
    imageUrlArray = imageArray;
    ScrollViewCount = [imageArray count];
    ScrollViewIndex = 0;
    NSLog(@"%@",imageArray);
    [self layoutImageViews];
}
@end
