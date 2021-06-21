//
//  SMAccount.m
    
//
//  Created by lucifer on 15/7/14.
  
//

#import "SMAccount.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation SMAccount
#define SMAccountFileName @"account.data"
MJCodingImplementation

- (BOOL)save
{
    // 1.获取沙河路径
    NSString *accountPath = [SMAccountFileName appendDocumentDir];

    // 2.将自己存储起来
    return [NSKeyedArchiver archiveRootObject:self toFile:accountPath];
}

+ (instancetype)accountFromSandbox
{
    // 1.获取沙河路径
    NSString *accountPath = [SMAccountFileName appendDocumentDir];
    
    // 2.取出存储的模型对象
    SMAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    
    // 3.返回模型对象
    return account;
    
}
-(NSMutableArray *)historyArr
{
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc]init];
    }
    return _historyArr;
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"auths":[SMAuths class]};
////    return @{@"groups":[NSString class]};
}

@end
