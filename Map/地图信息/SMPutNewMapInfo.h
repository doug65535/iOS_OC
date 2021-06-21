//
//  SMPutNewMapInfo.h
    
//
//  Created by lucifer on 15/8/12.
  
//

#import <UIKit/UIKit.h>

@class SMPutNewMapInfo;

@protocol SMPutNewMapInfoDelegate <NSObject>

-(void)didFinishUpdateMap:(SMCreatMap *)model;

@end

@interface SMPutNewMapInfo : UIViewController


@property (nonatomic,strong)SMCreatMap *mapModel;

@property(nonatomic,weak)id<SMPutNewMapInfoDelegate>delegate;

@end
