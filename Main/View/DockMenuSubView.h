//
//  DockMenuSubView.h
//  abcd
//
//  Created by leonshi on 6/20/14.
//  Copyright (c) 2014 leonshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DockMenuSubView : UITableView
-(void) setHidden:(BOOL)hidden;

-(void) setHidden:(BOOL)hidden withDirection:(BOOL) fromRightFlag;
@end
