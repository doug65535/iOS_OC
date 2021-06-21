//
//  SMAnnoDetail.h
    
//
//  Created by lucifer on 15/8/14.
  
//

#import <Foundation/Foundation.h>

@interface SMAnnoDetail : NSObject
/**
 *  坐标
 */
@property (nonatomic,copy)NSString *bdxy;

@property (nonatomic,copy)NSString *icon_id;

@property (nonatomic,strong)NSArray *img;

@property (nonatomic,copy)NSString *Lid;

@property (nonatomic,strong)NSArray *marker_attributes;

@property (nonatomic,copy)NSString *marker_layer_id;

@property (nonatomic,copy)NSString *rating;

@property (nonatomic,copy)NSString *title;

@end
