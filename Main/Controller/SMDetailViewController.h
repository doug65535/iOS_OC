//
//  SMDetailViewController.h
    
//
//  Created by lucifer on 15/7/20.
  
//

#import <UIKit/UIKit.h>

#import "DockMenuSubView.h"

#import "DockMenuView.h"
#import "SMPingLunViewController.h"

@interface SMDetailViewController : UIViewController<UIScrollViewDelegate,DockMenuItemDelegate>
/**
 *  展示数据
 */
@property (nonatomic,strong)SMStatus *modle;



/**
 *  点赞数据
 */

@property (nonatomic,strong)NSMutableArray *userLikers;


@property (nonatomic,retain)IBOutlet UIScrollView *mScrollView;


@property (nonatomic,retain) DockMenuView *mDockMenuView;

@property (nonatomic,retain)IBOutlet DockMenuView *mScrollDockMenuView;

@property (nonatomic,retain) DockMenuSubView *view1;
@property (nonatomic,retain) DockMenuSubView *view2;
@property (nonatomic,retain) DockMenuSubView *view3;


@property(nonatomic,getter=isneedset) BOOL isneedset;
@property(nonatomic,getter=isneedZan) BOOL isneedZan;
@end
