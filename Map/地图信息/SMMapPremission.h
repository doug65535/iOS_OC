//
//  SMMapPremission.h
    
//
//  Created by lucifer on 15/8/12.
  
//

#import <UIKit/UIKit.h>

@class SMMapPremission;
@protocol SMMapPremissionDelegate <NSObject>

-(void)didFinishPremisonEditStr:(NSString *)EditStr lookStr:(NSString *)LookStr;

@optional

-(void)paswordPass:(NSString *)Pwd;

@end


@interface SMMapPremission : UIViewController
/**
 *  编辑自己可见
 */
@property (weak, nonatomic) IBOutlet UISwitch *EditOwner;
/**
 *  编辑都可见
 */
@property (weak, nonatomic) IBOutlet UISwitch *EditPub;
/**
 *  仅自己可见
 */
@property (weak, nonatomic) IBOutlet UISwitch *LookOwner;

/**
 *  都可见
 */
@property (weak, nonatomic) IBOutlet UISwitch *LookPub;


/**
 *  输入密码可见
 */
@property (weak, nonatomic) IBOutlet UISwitch *LookPWD;

@property (nonatomic,strong)SMCreatMap *mapModel;

@property(nonatomic,weak)id<SMMapPremissionDelegate> delegate;



@property(nonatomic,getter=isComuOn)BOOL isComuon;
@end
