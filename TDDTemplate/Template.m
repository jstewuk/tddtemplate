//
//  Template.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "Template.h"
#import "TemplateParse.h"

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
    NSString *result = [self stringWithFieldsReplaced];
    if ([self hasRemainingTemplateFields:result]) {
        result = nil;
    } 
    return result;
}

- (NSString *)stringWithFieldsReplaced {
    NSString *result = self.templateText;
    NSString *templateVar = nil;
    for (NSString* name in [self.variableHash allKeys]) {
        templateVar = [NSString stringWithFormat:@"${%@}", name];
        result = [result stringByReplacingOccurrencesOfString:templateVar
                                                   withString:self.variableHash[name]];
    }
    return result;
}

- (BOOL)hasRemainingTemplateFields:(NSString*)string {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{.+\\}"
                                                                           options:0
                                                                             error:nil];
    NSTextCheckingResult *checkResult = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    BOOL isFieldFound = (checkResult.range.length > 0);
    return isFieldFound;
}

@end