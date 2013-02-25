//
//  Template.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright (c) 2013 StewartStuff. All rights reserved.
//

#import "Template.h"
#import "TemplateParse.h"
#import "SegmentInterface.h"

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
    NSArray *segments = [parser parseIntoSegments];
    return [self concatenate:segments];
}

- (NSString*)concatenate:(NSArray *)segments {
    NSMutableString *builtString = [NSMutableString string];
    NSError *error;
    for (id<SegmentInterface> segment in segments) {
        NSString *segStr = [segment evaluateWithVariables:self.variableHash error:&error];
        if (!segStr && error) {
            builtString = nil;
        } else if ( [segStr length] == 0 ) {
            ; // don't append!
        } else {
            [self appendSegment:segStr toResult:builtString error:nil];
        }
    }
    return builtString;
}

- (void)appendSegment:(NSString*)segment toResult:(NSMutableString *)mString error:(NSError**)error {
    [mString appendString:segment];
}

@end