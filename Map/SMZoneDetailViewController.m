//
//  SMZoneDetailViewController.m
    
//
//  Created by lucifer on 16/1/18.
   
//

#import "SMZoneDetailViewController.h"

@interface SMZoneDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *zoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *zoneDescription;
- (IBAction)backtoMap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backToMapBtn;

@end

@implementation SMZoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_zone) {
        self.zoneTitle.text = _zone.title;
        self.zoneDescription.text = _zone.Ldescription;

    }
    
    if (_line) {
        self.zoneTitle.text = _line.title;
        self.zoneDescription.text = _line.Description;
    }
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

- (IBAction)backtoMap:(UIButton *)sender {
    if (_zone) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.zone forKey:@"model"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetZoneNotification object:nil userInfo:dic];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (_line) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.line forKey:@"model"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetLineNotification object:nil userInfo:dic];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end
