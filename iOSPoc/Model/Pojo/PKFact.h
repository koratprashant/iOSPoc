//
//  PKFact.h
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKFact : NSObject
@property (nonatomic, strong) NSString *facts_title;
@property (nonatomic, strong) NSString *facts_description;
@property (nonatomic, strong) NSString *facts_imageHref;
@property (nonatomic, strong) NSData *imagedata;
/**
 * @description This is pojo mapper initialiser
 * @param factDetails input response as in NSMutableDictionary
 * @return It is retun the object of PKFact 
*/
-(instancetype )initWithData:(NSMutableDictionary *)factDetails;
@end
