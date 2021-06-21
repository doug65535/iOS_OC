//
//  SMDTDianZanModel.h
    
//
//  Created by lucifer on 15/8/25.
  
//

#import <Foundation/Foundation.h>
#import "SMUser.h"

#import "SMRepies.h"

@interface SMNotifications : NSObject

@property (nonatomic, strong)SMUser *like_user;

@property (nonatomic, copy) NSString *Lid;


@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, assign) BOOL read;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, strong) SMStatus *message;

@property(nonatomic,strong)SMRepies *reply;

@end







