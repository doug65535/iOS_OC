//
//  SMRepies.h
    
//
//  Created by lucifer on 15/7/24.
  
//

#import <Foundation/Foundation.h>
#import "SMUser.h"
#import "SMPingLun.h"

@interface SMRepies : NSObject

@property (nonatomic,copy)NSString *Lid;

@property (nonatomic,copy)NSString *body;

@property (nonatomic,strong)NSString  *floor;

@property (nonatomic,copy)NSString *created_at;


@property (nonatomic,getter=has_liked) BOOL has_liked;



@property (nonatomic,strong)SMUser *user;


@property(nonatomic,strong)SMStatus *message;

@property(nonatomic,strong)SMPingLun *reference_reply;

@end
