//
//  SMMapViewController.h
    
//
//  Created by lucifer on 15/7/31.
  
//

#import <UIKit/UIKit.h>
#import "SMCreatMap.h"



@class SMMapViewController;
@protocol SMMapViewControllerDelegate <NSObject>


@optional

-(void)closeMapAndMapCompose;
-(void)willRoladData:(SMCreatMap *)newModel;
-(void)didFinishLoadAnno;

@end

@interface SMMapViewController : UIViewController

@property (nonatomic,strong)SMCreatMap *mapModel;

@property (nonatomic,strong)SMCreatMap *creatModel;

@property (nonatomic,strong)SMStatus *modle;


@property(nonatomic,strong)id<SMMapViewControllerDelegate>delegate;

@end
