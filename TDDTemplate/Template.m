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
    TemplateParse *parser = [[TemplateParse alloc] initWithString:self.templateText];
    NSArray *segments = [parser parse];
    NSMutableString *builtString = [NSMutableString string];
    for (NSString* segment in segments) {
        [self appendSegment:segment toResult:builtString];
    }
    return builtString;
}

- (void)appendSegment:(NSString*)segment toResult:(NSMutableString *)mString {
    NSString *stringFromSegment = segment;
    if ([self isVariable:segment]) {
        NSString *varName = [self cleanString:segment];
        stringFromSegment = self.variableHash[varName];
        if (stringFromSegment == nil) {
            NSLog(@"variable: %@ is not defined.", varName);
            return;
        }
    }
    [mString appendString:stringFromSegment];
}

- (BOOL)isVariable:(NSString *)segment {
    return ([[segment substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"$"] &&
            [[segment substringWithRange:NSMakeRange([segment length] - 1, 1)] isEqualToString:@"}"]);
}

- (NSString *)cleanString:(NSString*)string {
    NSUInteger loc = 2;
    NSUInteger length = [string length] - loc - 1;
    return [string substringWithRange:NSMakeRange(loc, length)];
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