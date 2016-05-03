//
//  HJShopCollectionViewCell.m
//  waterFlow
//
//  Created by HJ on 16/5/1.
//  Copyright © 2016年 hujun. All rights reserved.
//

#import "HJShopCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HJShopCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation HJShopCollectionViewCell
- (void)setModel:(HJShopModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLabel.text = model.price;
}


@end
