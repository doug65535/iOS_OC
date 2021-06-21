//
//  SMEditAnnoTableViewCell.h
    
//
//  Created by lucifer on 16/1/29.
   
//

#import <UIKit/UIKit.h>

@interface SMEditAnnoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *laber;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;

@property(nonatomic,assign)NSInteger index;

@end
