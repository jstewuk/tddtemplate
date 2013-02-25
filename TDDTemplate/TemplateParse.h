//
//  TemplateParse.h
//  TDDTemplate
//
//  Created by James Stewart on 2/24/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateParse : NSObject
- (instancetype)initWithString:(NSString *)string;

- (NSArray *)parseIntoSegments;


@end
