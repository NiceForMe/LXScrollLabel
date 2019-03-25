//
//  ViewController.m
//  LXScrollLabel
//
//  Created by HSEDU on 2019/3/20.
//  Copyright © 2019年 HSEDU. All rights reserved.
//

#import "ViewController.h"
#import "LXScrollLabel.h"

@interface ViewController ()<LXScrollLabelDelegate,LXScrollLabelDataSource>
@property (nonatomic,strong) NSMutableArray *testArray;
@end

@implementation ViewController
#pragma mark - lazy load
- (NSMutableArray *)testArray
{
    if (!_testArray) {
        _testArray = [NSMutableArray arrayWithObjects:@{@"title" : @"这是第一个label文字",@"image" : @"test1"},@{@"title" : @"这是第二个label文字",@"image" : @"test2"}, nil];
    }
    return _testArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LXScrollLabel *label = [[LXScrollLabel alloc]initWithFrame:CGRectMake(20, 150, 220, 50) timeInterval:3.0];
    label.backgroundColor = [UIColor lightGrayColor];
    label.delegate = self;
    label.dataSource = self;
    [self.view addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.timeInterval = 1.0;
    });
    
}

- (NSInteger)numberOfRowsInScrollLabel:(LXScrollLabel *)scrollLabel
{
    return self.testArray.count;
}

- (UIView *)viewForScrollLabelAtIndex:(NSInteger)index
{
    NSDictionary *dict = self.testArray[index];
    UIView *view = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor purpleColor];
    label.text = dict[@"title"];
    [view addSubview:label];
    CGFloat labelWidth = [self getWidthWithText:label.text font:label.font];
    CGFloat labelHeight = [self getHeightByWidth:labelWidth text:label.text font:label.font];
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:10].active = YES;
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:labelWidth].active = YES;
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:labelHeight].active = YES;
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"image"]]];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView];
    [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeRight multiplier:1 constant:5].active = YES;
    [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20].active = YES;
    [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20].active = YES;
    return view;
}

- (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
- (CGFloat)getHeightByWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}


@end
