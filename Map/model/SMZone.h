//
//  SMZone.h
    
//
//  Created by lucifer on 16/1/13.
   
//

#import <Foundation/Foundation.h>
#import "SMGeometry.h"
#import "SMStyle.h"

@interface SMZone : NSObject


@property(nonatomic,copy)NSString *Lid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *Ldescription;
@property(nonatomic,copy)NSString *geometry_type;

@property(nonatomic,strong)SMGeometry *geometry;

@property(nonatomic,copy)NSString *smid;

@property(nonatomic,strong)SMStyle *style;
@end
