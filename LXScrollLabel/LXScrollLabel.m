//
//  LXScrollLabel.m
//  LoadAndInitializeTest
//
//  Created by HSEDU on 2018/9/20.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import "LXScrollLabel.h"

#define MAXSECTION 20

@interface LXScrollLabel()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger sectionCount;
@end

@implementation LXScrollLabel

- (instancetype)initWithFrame:(CGRect)frame timeInterval:(CGFloat)timeInterval
{
    if (self = [super initWithFrame:frame]) {
        if (timeInterval <= 0) {
            timeInterval = 2.0;
        }
        self.timeInterval = timeInterval;
        self.frame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.sectionCount = 1;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.bounces = NO;
    collectionView.backgroundColor = self.backgroundColor;
    collectionView.autoresizesSubviews = YES;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self addSubview:collectionView];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:1];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:1];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:1];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:1];
    [self addConstraints:@[top,left,right,bottom]];
}

#pragma mark - timer
- (void)addTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setTimeInterval:(CGFloat)timeInterval
{
    _timeInterval = timeInterval;
    [self removeTimer];
    [self addTimer];
}

#pragma mark - core function
- (void)autoScroll
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    if (item + 1 == [self.dataSource numberOfRowsInScrollLabel:self]) {
        item = 0;
        section++;
        self.sectionCount++;
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:section]];
    }else{
        item++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInScrollLabel:self];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    for (UILabel *label in cell.contentView.subviews) {
        [label removeFromSuperview];
    }
    cell.contentView.userInteractionEnabled = YES;
    UIView *view = [self.dataSource viewForScrollLabelAtIndex:indexPath.row];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:view];
    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectLabelWithScrollLabel:index:)]) {
        [self.delegate didSelectLabelWithScrollLabel:self index:indexPath.row];
    }
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
