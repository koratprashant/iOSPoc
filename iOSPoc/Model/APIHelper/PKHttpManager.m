//
//  PKHttpManager.m
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import "PKHttpManager.h"

@implementation PKHttpManager

#pragma mark - Initialiser
-(id)initWithUrlString:(NSString*)aURLString delegate:(id)APIDelegate withTag:(int)tag{
    self = [super init];
    if(self != nil){
        _delegate = APIDelegate;
        _tagAPI = tag;
        receiveddata = [[NSMutableData alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[aURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    return self;
}


#pragma mark - Connection Data delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveddata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if([self.delegate respondsToSelector:@selector(didConnectionFinishLoadingWithData:)]){
        [_delegate didConnectionFinishLoadingWithData:receiveddata];
    }
}
#pragma mark - Connection Delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(didConnectionFailedLoading)]){
        [_delegate didConnectionFailedLoading];
    }
}
#pragma mark -
@end
