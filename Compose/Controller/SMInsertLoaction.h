//
//  SMInsertLoaction.h
    
//
//  Created by lucifer on 15/9/2.
  
//

#import <UIKit/UIKit.h>


@class SMInsertLoaction;
@protocol SMInsertLoactionDelegate <NSObject>

-(void)finishLocate:(NSString *)locateStr;

@end


@interface SMInsertLoaction : UITableViewController
{
       BMKLocationService* _locService;
       BMKGeoCodeSearch* _geocodesearch;
}

@property(nonatomic,weak)id<SMInsertLoactionDelegate>delegate;

@end
