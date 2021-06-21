//
//  AppDelegate.m
    
//
//  Created by lucifer on 15/7/6.
 
//

#import "AppDelegate.h"
#import "SMTabBarController.h"

#import "UMSocial.h"


#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "SMNewFeautureViewController.h"

#import "UMCheckUpdate.h"
#import <Bugly/CrashReporter.h>

#import "JPUSHService.h"

#import "SMWebVc.h"
#import "SMDetailViewController.h"
#import "SMMapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    
    [JPUSHService handleRemoteNotification:userInfo];
}


//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification { [APService showLocalNotificationAtFront:notification identifierKey:nil]; }
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    SMLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
//}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];

//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"广播推荐" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSString *updateUrl = [userInfo valueForKey:@"updateUrl"];
            
            if (updateUrl) {
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            }
            
            
            NSString *webUrl = [userInfo valueForKey:@"webUrl"];
            
            if (webUrl) {
                SMWebVc *webVc = [[UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil]instantiateInitialViewController];
                webVc.url = webUrl;
                SMNavgationController *nav = [[SMNavgationController alloc]init];
                [nav addChildViewController:webVc];
                
                [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
            }
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            SMAccount *account = [SMAccount accountFromSandbox];
            
            [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
            
            NSString *postUrl = [userInfo valueForKey:@"postID"];
            
            if (postUrl) {
                NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@",postUrl];
                [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    SMStatus *status = [SMStatus objectWithKeyValues:responseObject];
                    SMDetailViewController *detailViewVC = [[UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil]instantiateInitialViewController];
                    detailViewVC.modle = status;
                    
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:detailViewVC];
                    
                    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"无法加载"];
                }];
            }
            
            NSString *mapUrl = [userInfo valueForKey:@"mapID"];
           
            if (mapUrl) {
                NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@.json",mapUrl];
                [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                SMCreatMap *mapModel = [SMCreatMap objectWithKeyValues:responseObject[@"info"]];
                    
                    SMMapViewController *mapVc = [[UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil]instantiateInitialViewController];
                    mapVc.mapModel = mapModel;
                    
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:mapVc];
                    
                    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"进入失败"];
                }];
            }
        }]];
        
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];

    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [UMCheckUpdate checkUpdateWithAppID:@"1044038090"  checkUpdateUrl:nil homeUrl:@"https://appsto.re/cn/khSo-.i" title:@"建议更新版本" cancelButtonTitle:@"取消" otherButtonTitles:@"去更新"];
    
    [UMCheckUpdate setLogEnabled:YES];
  
    

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {

        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    
    [JPUSHService setupWithOption:launchOptions appKey:@"ca4abfc7f33def47c4318341"
                          channel:@"Publish channel" apsForProduction:YES];
//    [JPUSHService setupWithOption:launchOptions];
    

    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *value = [remoteNotification valueForKey:@"app"];
//    SMLog(@"%@",value);
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    

         _mapManager = [[BMKMapManager alloc]init];

      BOOL ret = [_mapManager start:@"yTGV5yr8y9mxRXs8oUkoif2o"  generalDelegate:nil];
        if (!ret) {
            SMLog(@"manager start failed!");
        }
        // Add the navigation controller's view to the window and display.
        [self.window setRootViewController:navigationController];
        [self.window makeKeyAndVisible];
    
 


    
    [UMSocialData setAppKey:@"5655583467e58e740d0029f3"];

    
    

    [UMSocialWechatHandler setWXAppId:@"wxd204c64a55026731" appSecret:@"96e86aa5cbfe7ee36302e0d3d5f8d343" url:@"http://www.baidu.com"];


    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"881241837" secret:@"Secret：a77826e21a64df568b914b58cd9adc92" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    [UMSocialQQHandler setQQWithAppId:@"1102295727" appKey:@"4O8cWGGvpFNC5Suz" url:@"http://www.umeng.com/social"];
    
    
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    [self.window makeKeyAndVisible];

    

        
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *sandboxVersion = [defaults objectForKey:@"CFBundleShortVersionString"];
        

      
        if ([currentVersion compare:sandboxVersion] == NSOrderedDescending) {

            SMNewFeautureViewController *newfeatureVc = [[UIStoryboard storyboardWithName:@"SMNewFeautureViewController" bundle:nil]instantiateInitialViewController];
            self.window.rootViewController = newfeatureVc;
            

            [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
            [defaults synchronize];
        }else{
            SMTabBarController *tabBarVC = [[SMTabBarController alloc] init];
            self.window.rootViewController = tabBarVC;

        }

    

    

    [[CrashReporter sharedInstance] installWithAppId:@"900009255"];
    

    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {

    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}



- (void)applicationWillResignActive:(UIApplication *)application {
 
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

}

@end
