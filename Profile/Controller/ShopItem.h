//
//  ShopItem.h
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface ShopItem : UIButton
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;
@property (nonatomic, strong) BMKOLSearchRecord *shop;


@property (nonatomic,strong)BMKOfflineMap *offlineMap;
@end
