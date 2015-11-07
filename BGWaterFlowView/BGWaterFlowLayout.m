//
//  BGWaterFlowLayout.m
//  BGCollectionView
//
//  Created by user on 15/11/7.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGWaterFlowLayout.h"

#pragma mark - BGWaterFlowModel
@interface BGWaterFlowModel : NSObject
/**
 *  第几列
 */
@property (nonatomic, assign) NSInteger column;
/**
 *  列的高度
 */
@property (nonatomic, assign) CGFloat height;
+ (instancetype)modelWithColumn:(NSInteger)column;
@end

@implementation BGWaterFlowModel
+ (instancetype)modelWithColumn:(NSInteger)column{
    BGWaterFlowModel *model = [[[self class] alloc] init];
    model.column = column;
    model.height = 0.0f;
    return model;
}
@end

#pragma mark - BGWaterFlowLayout

@interface BGWaterFlowLayout ()
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSDictionary *cellLayoutInfoDic;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;
@end

@implementation BGWaterFlowLayout
#pragma mark - 计算方法

/**
 *  创建列的信息数组，内部是BGWaterFlowModel对象
 */
- (NSMutableArray *)columnInfoArray{
    NSMutableArray *columnInfoArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.columnNum; i++) {
        BGWaterFlowModel *model = [BGWaterFlowModel modelWithColumn:i];
        [columnInfoArr addObject:model];
    }
    return columnInfoArr;
}

/**
 * 数组排序，由于每次只有第一个model的高度会发生变化，所以这里的排序是比较第一个model与后面model，直到找到height比它大的对象
 */
- (void)sortArrayByHeight:(NSMutableArray *)cellLayoutInfoArray{
    BGWaterFlowModel *firstModel = cellLayoutInfoArray.firstObject;
    //删除第一个对象
    [cellLayoutInfoArray removeObject:firstModel];
    
    //查找到比它height更大的对象，然后插入在这个对象之前
    NSInteger arrCount = cellLayoutInfoArray.count;
    NSInteger i = 0;
    for (; i < arrCount; i++) {
        BGWaterFlowModel *object = cellLayoutInfoArray[i];
        if(object.height > firstModel.height){
            [cellLayoutInfoArray insertObject:firstModel atIndex:i];
            break;
        }
    }
    //如果遍历完都没找到比model.height更大的对象，则将它插入到最后
    if(i == arrCount){
        [cellLayoutInfoArray addObject:firstModel];
    }
}

#pragma mark - 重写父类方法
- (void)prepareLayout{
    [super prepareLayout];
    self.headerLayoutAttributes = nil;
    self.footerLayoutAttributes = nil;
    //计算宽度
    self.itemWidth = (self.collectionView.frame.size.width - (self.itemSpacing * (self.columnNum - 1)) - self.contentInset.left - self.contentInset.right) / self.columnNum;
    
    //头视图
    if(self.headerHeight > 0){
        self.headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.headerLayoutAttributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.headerHeight);
    }
    
    NSMutableDictionary *cellLayoutInfoDic = [NSMutableDictionary dictionary];
    NSMutableArray *columnInfoArray = [self columnInfoArray];
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++)  {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            //获取第一个model，以它的高作为y坐标
            BGWaterFlowModel *firstModel = columnInfoArray.firstObject;
            CGFloat y = firstModel.height;
            CGFloat x = self.contentInset.left + (self.itemSpacing + self.itemWidth) * firstModel.column;
            //获取item高度
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat itemHeight = [((id<BGWaterFlowLayoutDelegate>)self.collectionView.delegate) collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            //生成itemAttributes
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, y+self.contentInset.top+self.headerHeight, self.itemWidth, itemHeight);
            //保存新的列高，并进行排序
            firstModel.height += (itemHeight + self.itemSpacing);
            [self sortArrayByHeight:columnInfoArray];
            
            //保存布局信息
            cellLayoutInfoDic[indexPath] = itemAttributes;
        }
    }
    
    //保存到全局
    self.cellLayoutInfoDic = [cellLayoutInfoDic copy];
    
    //内容尺寸
    BGWaterFlowModel *lastModel = columnInfoArray.lastObject;
    //尾部视图
    if(self.footerHeight > 0){
        self.footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.footerLayoutAttributes.frame = CGRectMake(0, lastModel.height+self.headerHeight+self.contentInset.top+self.contentInset.bottom, self.collectionView.frame.size.width, self.footerHeight);
    }
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, lastModel.height+self.headerHeight+self.contentInset.top+self.contentInset.bottom+self.footerHeight);
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArrs = [NSMutableArray array];
    [self.cellLayoutInfoDic enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                                UICollectionViewLayoutAttributes *attributes,
                                                                BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArrs addObject:attributes];
        }
    }];
    
    if (self.headerLayoutAttributes && CGRectIntersectsRect(rect, self.headerLayoutAttributes.frame)) {
        [attributesArrs addObject:self.headerLayoutAttributes];
    }
    
    
    if (self.footerLayoutAttributes && CGRectIntersectsRect(rect, self.footerLayoutAttributes.frame)) {
        [attributesArrs addObject:self.footerLayoutAttributes];
    }
    
    return attributesArrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    return attributes;
}

#pragma mark - set method
- (void)setItemSpacing:(CGFloat)itemSpacing{
    _itemSpacing = itemSpacing;
    [self invalidateLayout];
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    [self invalidateLayout];
}

- (void)setColumnNum:(NSUInteger)columnNum{
    _columnNum = columnNum;
    [self invalidateLayout];
}

- (void)setContentInset:(UIEdgeInsets)contentInset{
    _contentInset = contentInset;
    [self invalidateLayout];
}

- (void)setHeaderHeight:(CGFloat)headerHeight{
    _headerHeight = headerHeight;
    [self invalidateLayout];
}

- (void)setFooterHeight:(CGFloat)footerHeight{
    _footerHeight = footerHeight;
    [self invalidateLayout];
}

@end
