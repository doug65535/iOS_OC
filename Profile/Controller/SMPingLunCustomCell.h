//
//  SMPingLunCustomCell.h
    
//
//  Created by lucifer on 15/8/24.
  
//

#import <UIKit/UIKit.h>
#import "SMPingLun.h"

//
//@class SMPingLunCustomCell;
//
//
//@protocol SMPingLunCustomCellDelegate <NSObject>
//
//- (void)cell:(SMPingLunCustomCell *)cell status:(SMPingLun *)status;
//
//@end


@interface SMPingLunCustomCell : UITableViewCell


@property(nonatomic,strong)SMPingLun *status;

@property(nonatomic,strong)SMUser *userModel;

//@property(nonatomic,weak)id<SMPingLunCustomCellDelegate>delegate;

-(CGFloat)rowHeight:(SMPingLun *)status;

@end
