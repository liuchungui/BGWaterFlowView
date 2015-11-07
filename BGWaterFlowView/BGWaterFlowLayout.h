//
//  BGWaterFlowLayout.h
//  BGCollectionView
//
//  Created by user on 15/11/7.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGWaterFlowLayout;

@protocol BGWaterFlowLayoutDelegate <UICollectionViewDelegate>
@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(BGWaterFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BGWaterFlowLayout : UICollectionViewLayout
/**
 *  瀑布流有多少列
 */
@property (nonatomic, assign) NSUInteger columnNum;
/**
 *  cell与cell之间的间距
 */
@property (nonatomic, assign) CGFloat itemSpacing;
/**
 *  cell之间的宽度
 */
@property (nonatomic, assign, readonly) CGFloat itemWidth;
/**
 *  内容缩进
 */
@property (nonatomic) UIEdgeInsets contentInset;
/**
 *  头视图的高度，默认为0；为0时，不显示头视图
 */
@property (nonatomic, assign) CGFloat headerHeight;
/**
 *  尾部视图的高度，默认为0；为0时，不显示尾部视图
 */
@property (nonatomic, assign) CGFloat footerHeight;
@end
