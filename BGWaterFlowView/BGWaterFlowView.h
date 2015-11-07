//
//  BGWaterFlowView.h
//  BGCollectionView
//
//  Created by user on 15/11/7.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGWaterFlowViewDataSource;
@protocol BGWaterFlowViewDelegate;
#pragma mark - BGWaterFlowView
/**
 *  瀑布流view
 */
@interface BGWaterFlowView : UIView
//@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<BGWaterFlowViewDataSource> dataSource;
@property (nonatomic, weak) id<BGWaterFlowViewDelegate> delegate;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/**
 *  刷新数据
 */
- (void)reloadData;
@end

#pragma mark - <BGWaterFlowViewDataSource>
@protocol BGWaterFlowViewDataSource <NSObject>

@required
- (NSInteger)waterFlowView:(BGWaterFlowView *)waterFlowView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)waterFlowView:(BGWaterFlowView *)waterFlowView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)waterFlowView:(BGWaterFlowView *)waterFlowView heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfSectionsInWaterFlowView:(BGWaterFlowView *)waterFlowView;
@end

#pragma mark - <BGWaterFlowViewDelegate>
@protocol BGWaterFlowViewDelegate <NSObject>

@optional
- (void)waterFlowView:(BGWaterFlowView *)waterFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark - BGRefreshWaterFlowView
@class BGRefreshWaterFlowView;
@protocol BGRefreshWaterFlowViewDelegate <BGWaterFlowViewDelegate>
@optional
- (void)pullDownWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView;
@end
/**
 *  带刷新的瀑布流
 */
@interface BGRefreshWaterFlowView: BGWaterFlowView
@property(nonatomic, assign)BOOL isPullMore;
@end
