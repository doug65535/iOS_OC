//
//  MJShopListController.m
//  仿天猫抽屉
//
//  Created by mj on 13-5-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define kRow 5  //弹出的btn个数

#import "ShopCell.h"

#import "MJShopListController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MJShopListController()

@property(strong,nonatomic)UITableView *tableView;
@end

@implementation MJShopListController

- (void)loadView {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kRow * kShopCellHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = tableView;
    self.tableView = tableView;
    
}



-(void)viewWillDisappear:(BOOL)animated
{
//    点开新的时候  会回到顶部开始浏览
     [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.shops.count + kColumn - 1) /kColumn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *identifier = @"UITableViewCell";
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.delegate = self;
        
        cell.offlineMap = self.offlineMap;
    }
    
    // 截出每一行所需要的Shop对象
    int location = indexPath.row * kColumn;
    int length = kColumn;
    if (location + length >= self.shops.count) {
        length = self.shops.count - location;
    }
    NSArray *parts = [self.shops subarrayWithRange:NSMakeRange(location, length)];
    
    // 设置Shops和行号
    [cell setShops:parts row:indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kShopCellHeight;
}



#pragma mark - 点击商品的代理
- (void)shop:(BMKOLSearchRecord *)shop clickAtRow:(int)row column:(int)column {
     NSDictionary *dic = [NSDictionary dictionaryWithObject:shop forKey:@"SMClickProviceCity"];
    NSNotification * notice = [NSNotification notificationWithName:@"SMClickProviceCity" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    [self.tableView reloadData];
}
@end
