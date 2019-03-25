//
//  LXScrollLabel.h
//  LoadAndInitializeTest
//
//  Created by HSEDU on 2018/9/20.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXScrollLabel;

@protocol LXScrollLabelDataSource <NSObject>

- (NSInteger)numberOfRowsInScrollLabel:(LXScrollLabel *)scrollLabel;
- (UIView *)viewForScrollLabelAtIndex:(NSInteger)index;

@end

@protocol LXScrollLabelDelegate <NSObject>

- (void)didSelectLabelWithScrollLabel:(LXScrollLabel *)scrollLabel index:(NSInteger)index;

@end

@interface LXScrollLabel : UIView

/**
 delegate
 */
@property (nonatomic,weak) id <LXScrollLabelDelegate> delegate;

/**
 data source
 */
@property (nonatomic,weak) id <LXScrollLabelDataSource> dataSource;

/**
 滚动时间间隔
 */
@property (nonatomic,assign) CGFloat timeInterval;

/**
 唯一的初始化方法

 @param frame frame
 @param timeInterval 时间间隔
 @return scroll label
 */
- (instancetype)initWithFrame:(CGRect)frame timeInterval:(CGFloat)timeInterval;
@end
