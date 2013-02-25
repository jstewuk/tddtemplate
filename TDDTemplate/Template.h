//
//  Template.h
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject
- (instancetype)initWithString:(NSString *)templateString;
- (void)addVariable:(NSString*)name withValue:(NSString*)value;
- (NSString*)evaluate;
@end
