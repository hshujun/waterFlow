//
//  HJWaterFlowLayout.h
//  waterFlow
//
//  Created by HJ on 16/4/30.
//  Copyright © 2016年 hujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HJWaterFlowLayout;

@protocol HJWaterFlowLayoutDelegate <NSObject>
@required
- (CGFloat)waterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout     heightForItemAtIndex:(NSInteger )index width:(CGFloat)width;
@optional
// 列数
- (NSInteger)columnCountInWaterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout;

// 列间距
- (CGFloat)columnMarginInWaterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout;;

// 行间距
- (CGFloat)rowMarginInWaterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout;;

// 四周间距
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout;;

@end
@interface HJWaterFlowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<HJWaterFlowLayoutDelegate> delegate;

@end
