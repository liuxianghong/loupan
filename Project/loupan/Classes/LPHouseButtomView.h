//
//  LPHouseButtomView.h
//  loupan
//
//  Created by 刘向宏 on 15-4-2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPHouseButtomViewDelegate <NSObject>
- (void)DoCollection;
- (void)DoShar;
- (void)DoCall;
@end

@interface LPHouseButtomView : UIView
@property (nonatomic ,strong) IBOutlet UIButton *button1;
@property (nonatomic ,strong) IBOutlet UIButton *button2;
@property (nonatomic ,strong) IBOutlet UIButton *button3;
@property (nonatomic, weak) id <LPHouseButtomViewDelegate> delegate;
@end
