//
//  SMGuanzhuFensiCell.h
    
//
//  Created by lucifer on 15/9/30.
 
//

#import <UIKit/UIKit.h>

@interface SMGuanzhuFensiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *guanzhu;
- (IBAction)guanzhu:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detaititle;
@property (weak, nonatomic) IBOutlet UIImageView *loginView;


@property(nonatomic,strong)SMUser *user;

@end
