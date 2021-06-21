//
//  SMEditAnnoVC.h
    
//
//  Created by lucifer on 15/8/13.
  
//

#import <UIKit/UIKit.h>
#import "SMAnno.h"
#import "SMAttributes.h"

@class SMEditAnnoVC;
@protocol SMEditAnnoVCDelegate <NSObject>



-(void)willgiveToDetail:(NSMutableArray *)images title:(NSString *)title detailTitle:(NSString *)detailTitle  makerId:(NSString *)makerId;

@end




@interface SMEditAnnoVC : UIViewController

#define SMDetailEditAnnoNotification @"detailEditAnnoNotification"
#define SMDetailDeleteAnnoNotification @"detailDeleteAnnoNotification"

@property(nonatomic,assign)CLLocationCoordinate2D coordinate;


@property(nonatomic,assign)float level;

@property(nonatomic,strong)SMCreatMap *mapModel;


@property(nonatomic,weak)id<SMEditAnnoVCDelegate>delegate;
//@property(nonatomic,copy)NSString *annoID;
@property(nonatomic,strong)BMKPoiInfo *poiModel;


@property(nonatomic,strong)SMAnno *annoModel;

@property (nonatomic,strong)NSMutableArray *images;

@property (nonatomic,strong)NSMutableArray *imgArr;

//拍照定位相关属性
@property(nonatomic,strong)UIImage *temImage;
@property(nonatomic,copy)NSString *altitude;
@property(nonatomic,copy)NSString *longtitude;
@property(nonatomic,copy)NSString *temImageTitle;

@property(nonatomic,copy)NSString *finalStr;

@property(nonatomic,assign)BOOL isAddAnno;

@property(nonatomic,strong)NSArray *attr;

@end
