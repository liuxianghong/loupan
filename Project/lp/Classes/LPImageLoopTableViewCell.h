//
//  LPImageLoopTableViewCell.h
//  loupan
//
//  Created by 刘向宏 on 15-3-30.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPImageLoopTableViewCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,weak) IBOutlet UIPageControl *pageControl;
-(void)setImageUrlList:(NSArray *)imageArray;
@end
