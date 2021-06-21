//
//  SMGeometry.h
    
//
//  Created by lucifer on 16/1/13.
   
//

#import <Foundation/Foundation.h>
#import "SMPoints.h"

@interface SMGeometry : NSObject

@property(nonatomic,strong)NSArray *points;

@property(nonatomic,copy)NSString *smid;


@property(nonatomic,strong)SMPoints *center;

//数组paths 未添加 不知道什么意思       "parts": [22] 区域点的个数



@end
