//
//  HJWaterFlowLayout.m
//  waterFlow
//
//  Created by HJ on 16/4/30.
//  Copyright © 2016年 hujun. All rights reserved.
//

#import "HJWaterFlowLayout.h"
/** 列数 */
static const NSInteger columnCount = 3;

/** 列间距 */
static const CGFloat columnMargin = 10;

/** 行间距 */
static const CGFloat  rowMargin = 10;

/** 四周间距 */

static const  UIEdgeInsets edgeInsets = {10,10,10,10};


@interface HJWaterFlowLayout ()

// 存放所有 cell 的布局属性
@property (nonatomic, strong) NSMutableArray *attrArr;
@property (nonatomic, strong) NSMutableArray *columnHeights;
- (NSInteger)colunmCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;
@end

@implementation HJWaterFlowLayout

// 列数
- (NSInteger)colunmCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }
    return columnCount;
}

// 列间距
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }
    return columnMargin;
}

// 行间距
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }
    return rowMargin;
}

// 四周间距
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetInWaterFlowLayout:self];
    }
    return edgeInsets;
}

#pragma mark -懒加载
- (NSMutableArray *)attrArr
{
    if (_attrArr == nil) {
        _attrArr = [NSMutableArray array];
    }
    return _attrArr;
}

- (NSMutableArray *)columnHeights
{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

// 初始化布局
- (void)prepareLayout
{
    [super prepareLayout];
    // 初始化前清空高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.colunmCount; i++) {
        [self.columnHeights addObject:@(0)];
    }
    
    // 清空属性数组
    [self.attrArr removeAllObjects];
    
    // 创建布局属性的数组
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrArr addObject:attr];
    }
}


// 决定 cell 的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArr;
}

// 决定每个 cell 的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 取出最短的一列
    CGFloat shortColumnHeight = [self.columnHeights[0] doubleValue];
    NSInteger index = 0;
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        if ([self.columnHeights[i] doubleValue] < shortColumnHeight) {
            shortColumnHeight = [self.columnHeights[i] doubleValue];
            index = i;
        }
    }
    
    CGFloat w = (self.collectionView.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.columnMargin * (self.colunmCount - 1))) / self.colunmCount;
//    CGFloat h = arc4random_uniform(100) + 50;
   CGFloat h =  [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item width:w];
    CGFloat x = self.edgeInsets.left + index * (w + self.columnMargin);
    CGFloat y = shortColumnHeight + self.rowMargin;
    attr.frame = CGRectMake(x, y, w, h);
    
    // 更新最短一列的高度
    self.columnHeights[index] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

// collectionView 的 contentSize 的大小
- (CGSize)collectionViewContentSize
{
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (NSInteger i = 1; i < self.colunmCount; i++) {
        if ([self.columnHeights[i] doubleValue] > maxColumnHeight) {
            maxColumnHeight = [self.columnHeights[i] doubleValue];
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}
@end
