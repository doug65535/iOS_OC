//
//  SMLine.m
    
//
//  Created by lucifer on 16/1/28.
   
//

#import "SMLine.h"

@implementation SMLine

+(NSDictionary *)objectClassInArray
{
   return  @{@"nodes":[SMLinePoint class],@"markers":[SMAnno class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Lid" : @"id", @"Description":@"description"};
}


@end
