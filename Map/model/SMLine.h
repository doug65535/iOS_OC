//
//  SMLine.h
    
//
//  Created by lucifer on 16/1/28.
   
//

#import <Foundation/Foundation.h>
#import "SMLinePoint.h"
#import "SMLineStyle.h"
#import "SMAnno.h"
@interface SMLine : NSObject
@property(nonatomic,copy)NSString *Lid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *Description;
@property(nonatomic,strong)NSArray *nodes;
@property(nonatomic,strong)SMLineStyle *style;
//@property(nonatomic,strong)SMLinePoint *p;

@property(nonatomic,strong)NSArray *markers;

@end
