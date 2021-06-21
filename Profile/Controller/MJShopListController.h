//
//  MJShopListController.h
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopCellDelegate;
@interface MJShopListController : UIViewController<UITableViewDataSource, UITableViewDelegate, ShopCellDelegate>
@property (nonatomic, strong) NSArray *shops;

@property (nonatomic,strong)BMKOfflineMap *offlineMap;
@end
