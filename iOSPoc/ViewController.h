//
//  ViewController.h
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PKHttpManager.h"
@interface ViewController : UIViewController{
    PKHttpManager *httpManager;
}
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tblFacts;


@end

