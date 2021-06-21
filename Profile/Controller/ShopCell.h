//
//  ShopCell.h
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define kShopCellHeight 44   //弹出的btn 高度
#define kColumn 1



@protocol ShopCellDelegate <NSObject>
- (void)shop:(BMKOLSearchRecord *)shop clickAtRow:(int)row column:(int)column;
@end

@interface ShopCell : UITableViewCell
@property (nonatomic, weak) id<ShopCellDelegate> delegate;
- (void)setShops:(NSArray *)shops row:(int)row;


@property (nonatomic,strong)BMKOfflineMap *offlineMap;
@end