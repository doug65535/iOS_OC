//
//  SMAnnoListViewController.h
    
//
//  Created by lucifer on 15/8/3.
  
//

#import <UIKit/UIKit.h>
#import "SMAnno.h"

#import "SMAnnoDetailViewController.h"

@interface SMAnnoListViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *annoDataArr;


@property(nonatomic,strong)SMCreatMap *mapModel;


@property(nonatomic,strong)NSMutableArray *zonesArr;

@property(nonatomic,strong)NSMutableArray *linesArr;

@end
