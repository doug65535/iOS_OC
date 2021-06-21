//
//  SMDianZanCell.h
    
//
//  Created by lucifer on 15/8/25.
  
//

#import <UIKit/UIKit.h>
#import "SMNotifications.h"

@interface SMDianZanCell : UITableViewCell


@property(nonatomic,strong)SMNotifications *status;
@property(nonatomic,strong)SMNotifications *status1;
@property(nonatomic,strong)SMNotifications *status0;

-(CGFloat)cellHeightWithStatus:(SMNotifications *)status;
-(CGFloat)cellHeightWithStatus0:(SMNotifications *)status0;
-(CGFloat)cellHeightWithStatus1:(SMNotifications *)status1;
@end
