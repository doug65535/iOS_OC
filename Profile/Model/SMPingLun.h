//
//  SMPingLun.h
    
//
//  Created by lucifer on 15/8/20.
  
//

#import <Foundation/Foundation.h>
@interface SMPingLun : NSObject


@property(nonatomic,copy)NSString *Lid;

@property(nonatomic,copy)NSString *body;

@property(nonatomic,copy)NSString *source;

@property(nonatomic,copy)NSString *floor;

@property(nonatomic,copy)NSString *reference_id;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *updated_at;

@property(nonatomic,copy)NSString *has_liked;

@property(nonatomic,strong)SMStatus *message;

@property(nonatomic,strong)SMUser *user;

@end
