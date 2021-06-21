//
//  ShopTypeCell.h
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShopTypeCellHeight 44



@interface ShopTypeCell : UITableViewCell
// 显示\隐藏底部的线
- (void)showBottomLine:(BOOL)show;
// 最开始的Y
@property (nonatomic, assign) CGFloat originY;
// 最上面的那层View
@property (nonatomic, readonly) UIView *coverView;
//- (void)setShopType:(ShopType *)type isLast:(BOOL)isLast;
@end
