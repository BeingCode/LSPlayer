//
//  NSDictionary+NTESJson.h
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (NTESJson)
- (NSString *)jsonBody;

- (NSString *)jsonString: (NSString *)key;

- (NSDictionary *)jsonDict: (NSString *)key;
- (NSArray *)jsonArray: (NSString *)key;
- (NSArray *)jsonStringArray: (NSString *)key;


- (BOOL)jsonBool: (NSString *)key;
- (NSInteger)jsonInteger: (NSString *)key;
- (long long)jsonLongLong: (NSString *)key;
- (unsigned long long)jsonUnsignedLongLong:(NSString *)key;

- (double)jsonDouble: (NSString *)key;
@end
