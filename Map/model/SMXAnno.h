//
//  SMXAnno.h
    
//
//  Created by lucifer on 16/1/26.
   
//

#import <Foundation/Foundation.h>
#import "SMAnno.h"

@interface SMXAnno : BMKPointAnnotation

@property(nonatomic,copy)NSString *url;

@property(nonatomic,strong)NSMutableArray *attributes;


@property(nonatomic,strong)SMAnno *annoModel;

@end
