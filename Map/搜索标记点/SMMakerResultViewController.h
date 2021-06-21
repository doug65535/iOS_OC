//
//  SMMakerResultViewController.h
    
//
//  Created by lucifer on 15/8/6.
  
//

#import <UIKit/UIKit.h>


@class SMMakerResultViewController;

//@protocol SMMakerResultViewControllerDelegate <NSObject>
//
//-(void)didScroll;
//
//@end
#define SMSectetAnnoNotification @"sectetAnnoNotification"
#define SMSectetPOIseachNotification @"sectetPOIseachNotification"
#define SMSectetZoneNotification @"sectetZoneNotification"
#define SMSectetLineNotification @"sectetLineNotification"
@interface SMMakerResultViewController : UITableViewController

/** 搜索条件 */
@property (nonatomic, copy) NSString *searchText;

@property(nonatomic,strong)NSMutableArray *annoModelArr;


@property(nonatomic,strong)NSMutableArray *poimodel;
@property(nonatomic,strong)SMCreatMap *mapmodel;


@property(nonatomic,strong) BMKPoiSearch *poisearch;


@property(nonatomic,strong)NSMutableArray *zonesArr;
@property(nonatomic,strong)NSMutableArray *linesArray;

//@property(nonatomic,weak)id<SMMakerResultViewControllerDelegate>delegate;
@end
