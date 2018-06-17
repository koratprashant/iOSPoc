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
-(void)downloadImageFromStringURL:(NSString*)strUrl withCompletion:(void(^)(NSData *))callback{
    NSURL *url = [NSURL URLWithString:[strUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        callback(data);
    }];
}

#pragma mark - Connection Data delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveddata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if([self.delegate respondsToSelector:@selector(didConnectionFinishLoadingWithData:)]){
        NSString  *strData = [[NSString alloc] initWithData:receiveddata encoding:NSISOLatin1StringEncoding];
        NSData *properEncodeData = [strData dataUsingEncoding:NSUTF8StringEncoding];

        [_delegate didConnectionFinishLoadingWithData:[NSMutableData dataWithData:properEncodeData]];
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
