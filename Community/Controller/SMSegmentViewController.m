//
//  SMSegmentViewController.m
    
//
//  Created by lucifer on 15/7/30.
  
//

#import "SMSegmentViewController.h"
#import "SMMComposeViewController.h"
@interface SMSegmentViewController ()
- (IBAction)segementChange:(UISegmentedControl *)sender;


@end

@implementation SMSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segement.tintColor = [UIColor colorWithRed:255.0 /255.0  green:150.0 /255.0 blue:20.0/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishCompose) name:SMFinishCompose object:nil];
}

-(void)didFinishCompose
{
     self.segement.selectedSegmentIndex = 0;
//    [self.delegate didChangeViewAtIndex:1 sender:self.segement];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)segementChange:(UISegmentedControl *)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(didChangeViewAtIndex:sender:)]) {
                [self.delegate didChangeViewAtIndex:0 sender:sender];
            }
            break;
            
        case 1:
            if ([self.delegate respondsToSelector:@selector(didChangeViewAtIndex:sender:)]) {
                [self.delegate didChangeViewAtIndex:1 sender:sender];
            }
            break;
            
     
    }
    
    
}
@end
