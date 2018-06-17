//
//  PKHttpManager.h
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 Manage API via delegate
 */
@protocol APIDelegate <NSObject>
/**
 * Description This Protocol method is use to manage successful response from API
 * response this is response kind of NSMutableData
 */
-(void)didConnectionFinishLoadingWithData:(NSMutableData *) response;
/**
 * Description This Protocol method is use to manage failed response from API 
 */
-(void)didConnectionFailedLoading;
@end

@interface PKHttpManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *connection;
    NSMutableData *receiveddata;
}
@property (assign, nonatomic) id <APIDelegate> delegate;
@property(nonatomic,readwrite)int tagAPI;
/**
 * @description This API used to initilise httpmanagger
 * @param aURLString URL to load in NSString format
 * @param APIDelegate Delegate to owner class
 * @param tag tag to differentiate multiple request in same class
 */
-(id)initWithUrlString:(NSString*)aURLString delegate:(id)APIDelegate withTag:(int)tag;
/**
 * @description This API is use to download image
 * @param strUrl URL to load in NSString format
 * @param callback This completion handler is retun the image data based on provided url
 */
-(void)downloadImageFromStringURL:(NSString*)strUrl withCompletion:(void(^)(NSData *))callback;
@end
