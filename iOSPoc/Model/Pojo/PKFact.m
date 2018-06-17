//
//  PKFact.m
//  iOSPoc
//
//  Created by korat prashant on 16/06/18.
//  Copyright © 2018 korat prashant. All rights reserved.
//

#import "PKFact.h"

@implementation PKFact
-(instancetype )initWithData:(NSMutableDictionary *)factDetails{
    self = [super init];
    if(self !=nil){
    
            for (NSString *key in factDetails) {
                NSString *setKey =[NSString stringWithFormat:@"setFacts_%@:",key];
                if([self respondsToSelector:NSSelectorFromString(setKey)]){
                    if([factDetails valueForKey:key] == [NSNull null]){
                        [self setValue:@"" forKey:[NSString stringWithFormat:@"facts_%@",key]];
                    }else{
                         [self setValue:[factDetails objectForKey:key] forKey:[NSString stringWithFormat:@"facts_%@",key]];
                    }
                   
                }
            }
        }
    return self;
}
@end
