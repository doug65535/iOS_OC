//
//  SMAboutViewController.m
    
//
//  Created by lucifer on 15/8/24.
  
//

#import "SMAboutViewController.h"

@interface SMAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutVersion;

@end

@implementation SMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
     NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *showVersion = [NSString stringWithFormat:@"地图慧 %@",app_Version];
    self.aboutVersion.text = showVersion;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
