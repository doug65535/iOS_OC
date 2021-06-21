

#import "SMBallScroViewController.h"
#import "DBSphereView.h"

@interface SMBallScroViewController ()

@property (nonatomic, retain) DBSphereView *sphereView;


@property (nonatomic,strong) NSMutableArray *btnArr;

@end

@implementation SMBallScroViewController

@synthesize sphereView;

- (void)viewDidLoad {
    [super viewDidLoad];
    sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(35 , 0, 250, 250)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.btnArr = array;
    for (NSInteger i = 0; i < 5; i ++) {
        [self setBtnTitle:@"地理科普"];
        [self setBtnTitle:@"教育问答"];
        [self setBtnTitle:@"历史军事"];
        [self setBtnTitle:@"旅游风光"];
        [self setBtnTitle:@"制定地图"];
        [self setBtnTitle:@"灌水八卦"];
    }
    [sphereView setCloudTags:array];
    sphereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sphereView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setBtnTitle:(NSString *)titleText 
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:[NSString stringWithFormat:@"%@", titleText] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.];
    btn.frame = CGRectMake(0, 0, 60, 20);
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArr addObject:btn];
    [sphereView addSubview:btn];
}

- (void)buttonPressed:(UIButton *)btn
{
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [sphereView timerStart];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(didbuttonPressed:)]) {
        [self.delegate didbuttonPressed:btn];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
