//
//  SMTabBar2.h
    
//
//  Created by lucifer on 15/7/7.
 
//

#import <UIKit/UIKit.h>

@class SMTabBar;
@protocol SMTabBarDelegate <NSObject>

- (void)tabBar:(SMTabBar *)tabBar selectedBtnFrom:(NSInteger)from to:(NSInteger)to;


- (void)tabBar:(SMTabBar *)tabBar selectedPlusBtn:(UIButton *)plusBtn;

@end


@interface SMTabBar : UIView

/**
 *  添加一个按钮
 *
 *  @param item 按钮需要显示的数据
 */
- (void)addItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<SMTabBarDelegate> delegate;

@end

