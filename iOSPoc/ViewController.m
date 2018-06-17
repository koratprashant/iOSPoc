//
//  ViewController.m
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import "ViewController.h"
#import "PKFact.h"
#import "PKFactsCell.h"

@interface ViewController () <APIDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (nonatomic, strong) NSMutableArray *arrListOfFacts;
/**
 * @Description This method is use for downloading image lazily
 * @param cellFact it is PKFactsCell row to download image
 * @param objFact it is PKFact object to content of row
 */
-(void)downloadImageForCell :(PKFactsCell *)cellFact  withObject:(PKFact *)objFact;

@end

@implementation ViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Self sizing of tableview
    _tblFacts.estimatedRowHeight = 67 ;
    _tblFacts.rowHeight = UITableViewAutomaticDimension;
    _tblFacts.separatorInset = UIEdgeInsetsZero;
    
    // Refresh data
    [self pushToRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getListOfFact];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - APIDelegate
-(void)didConnectionFinishLoadingWithData:(NSMutableData *) response{
    NSError *parseError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&parseError];
    if(parseError==nil){
        NSString *mainTitle = [json objectForKey:@"title"];
        self.title = mainTitle;
        NSMutableArray *arrRows = [json objectForKey:@"rows"];
        for (NSMutableDictionary *factDetails in arrRows) {
            PKFact *Fact = [[PKFact alloc] initWithData:factDetails];
            if(_arrListOfFacts==nil){
                _arrListOfFacts = [[NSMutableArray alloc] init];
            }
            [_arrListOfFacts addObject:Fact];
        }
        [_tblFacts reloadData];
    }
    
}
-(void)didConnectionFailedLoading{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong, please try againt" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
     [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Pull to Refresh
-(void)pushToRefresh{
    // Initialize the refresh control.
    if(_refreshControl==nil){
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor purpleColor];
    _refreshControl.tintColor = [UIColor redColor];
    [_refreshControl addTarget:self
                        action:@selector(getLatestFacts)
                  forControlEvents:UIControlEventValueChanged];
    }   
    if (@available(iOS 10.0, *)) {
        // iOS version greater than 10 have direct refresh controll setting property
        [_tblFacts setRefreshControl:_refreshControl];
    } else {
        // Fallback on earlier versions
        [_tblFacts addSubview:_refreshControl];
    }
}
- (void)getLatestFacts
{

    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
        // Reload table data
        [_arrListOfFacts removeAllObjects];
        [_tblFacts reloadData];
        [self getListOfFact];
    }
}
#pragma mark - API
// Get list of Fact API
-(void)getListOfFact{
   httpManager =(PKHttpManager *) [[PKHttpManager alloc] initWithUrlString:kGetFactsUrl delegate:self withTag:0];
    
}
#pragma mark - UITableviewDelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_arrListOfFacts.count >0){
        return  _arrListOfFacts.count ;
    }else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue-Italic" size:20];
        [messageLabel sizeToFit];
        
        _tblFacts.backgroundView = messageLabel;
        _tblFacts.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellReusalbeId = @"PKFactsCell";
    PKFactsCell *cellFact = [tableView dequeueReusableCellWithIdentifier:cellReusalbeId];
    PKFact *fact = [_arrListOfFacts objectAtIndex:indexPath.row];
    cellFact.lblTitle.text = fact.facts_title;
    cellFact.lblDescription.text = fact.facts_description;
    [cellFact.factImage setImage:nil]; //default Image is nil or any placeholder
    // To check If image URL exist
    if(fact.facts_imageHref.length>0 ){
        if(fact.imagedata==nil){
            // If image is not download, download it
            [self downloadImageForCell:cellFact withObject:fact];
        }else{
            //image downloaded from the server
            [cellFact.factImage setImage:[UIImage imageWithData:fact.imagedata]];
        }
    }
    return cellFact;
}
-(void)downloadImageForCell :(PKFactsCell *)cellFact  withObject:(PKFact *)objFact {
        [cellFact.activityView startAnimating];
        [self->httpManager downloadImageFromStringURL:objFact.facts_imageHref withCompletion:^(NSData * data) {
            [cellFact.activityView stopAnimating];
            if(data){
                objFact.imagedata = data;
                cellFact.factImage.image = [UIImage imageWithData:objFact.imagedata];
            }
        }];

}
@end
