//
//  SMAnnoDetailViewController.h
    
//
//  Created by lucifer on 15/8/5.
  
//

#import <UIKit/UIKit.h>
#import "SMAnno.h"

#define SMSectetAnnoNotification @"sectetAnnoNotification"


@interface SMAnnoDetailViewController : UIViewController


@property (nonatomic,strong)SMAnno *annoModel;

@property(nonatomic,strong)SMCreatMap *mapModel;


@property(nonatomic,copy)NSString *finalUrl;

@end
