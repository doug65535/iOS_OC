//
//  SMZoneDetailViewController.h
    
//
//  Created by lucifer on 16/1/18.
   
//

#import <UIKit/UIKit.h>
#import "SMZone.h"
#import "SMLine.h"

#define SMSectetZoneNotification @"sectetZoneNotification"

#define SMSectetLineNotification @"sectetLineNotification"

@interface SMZoneDetailViewController : UIViewController

@property(nonatomic,strong)SMZone *zone;
@property(nonatomic,strong)SMLine *line;



@end
