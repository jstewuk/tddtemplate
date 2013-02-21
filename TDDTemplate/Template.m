//
//  Template.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "Template.h"

@interface Template ()
@property (nonatomic, strong) NSMutableDictionary *variableHash;
@property (nonatomic, copy) NSString *templateText;
@end

@implementation Template

- (instancetype)initWithString:(NSString *)templateString  {
    self = [super init];
    if (self) {
        _templateText = templateString;
        _variableHash = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addVariable:(NSString*)name withValue:(NSString*)value {
    [self.variableHash addEntriesFromDictionary:@{name : value}];
}

- (NSString*)evaluate {
    NSString *result = self.templateText;
    NSString *templateVar = nil;
    for (NSString* name in [self.variableHash allKeys]) {
        templateVar = [NSString stringWithFormat:@"${%@}", name];
        result = [result stringByReplacingOccurrencesOfString:templateVar
                                                        withString:self.variableHash[name]];
    }
    return result;
}

@end