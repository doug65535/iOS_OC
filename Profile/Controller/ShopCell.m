//
//  ShopCell.m
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ShopCell.h"
#import "ShopItem.h"


#define kTagPrefix 20

@implementation ShopCell

#pragma mark 监听商品点击
- (void)shopClick:(ShopItem *)item {
    if ([self.delegate respondsToSelector:@selector(shop:clickAtRow:column:)]) {
        [self.delegate shop:item.shop clickAtRow:item.row column:item.column];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = kWidth / kColumn;
        for (int i = 0; i<kColumn; i++) {
            CGRect frame = CGRectMake(i*width, 0, width, kShopCellHeight);
            ShopItem *item = [[ShopItem alloc] initWithFrame:frame];
            
        
            
            item.tag = kTagPrefix + i;
            item.column = i;
            [item addTarget:self action:@selector(shopClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:item];
        }
    }
    return self;
}

- (void)setShops:(NSArray *)shops row:(int)row{
    int count = shops.count;
    
    for (int i = 0; i<kColumn; i++) {
        ShopItem *item = (ShopItem *)[self viewWithTag:kTagPrefix + i];
        item.row = row;
        if (i >= count) {
            item.hidden = YES;
        } else {
            item.hidden = NO;
            item.shop = [shops objectAtIndex:i];
                item.offlineMap = _offlineMap;
        }
    }
}
@end
