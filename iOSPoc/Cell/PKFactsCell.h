//
//  PKFactsCell.h
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PKFact;
@interface PKFactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *factImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end
