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
    return [self concatenate:segments];
}

- (NSString*)concatenate:(NSArray *)segments {
    NSMutableString *builtString = [NSMutableString string];
    NSError *error;
    for (NSString* segment in segments) {
        [self appendSegment:segment toResult:builtString error:&error];
        if (error) {
            builtString = nil;
        }
    }
    return builtString;
}


- (void)appendSegment:(NSString*)segment toResult:(NSMutableString *)mString error:(NSError**)error {
    NSString *stringFromSegment = segment;
    if ([Template isVariable:segment]) {
        stringFromSegment = [self evaluateVariable:segment error:error];
    }
    if (stringFromSegment) {
        [mString appendString:stringFromSegment];
    } else {
        mString = nil;
    }
}

- (NSString *)evaluateVariable:(NSString *)segment error:(NSError**)error {
    NSString *stringFromSegment=segment;
    NSString *varName = [Template cleanString:segment];
    stringFromSegment = self.variableHash[varName];
    if (stringFromSegment == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:101
                                     userInfo:@{@"userInfo": @"variable not defined", @"missingVariable" : varName}];
        }
        NSLog(@"variable: %@ is not defined.", varName);
        return nil;
    }
    return stringFromSegment;
}

+ (BOOL)isVariable:(NSString *)segment {
    return ([[segment substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"$"] &&
            [[segment substringWithRange:NSMakeRange([segment length] - 1, 1)] isEqualToString:@"}"]);
}

+ (NSString *)cleanString:(NSString*)string {
    NSUInteger loc = 2;
    NSUInteger length = [string length] - loc - 1;
    return [string substringWithRange:NSMakeRange(loc, length)];
}
    
@end