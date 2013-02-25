//
//  TemplateParseSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "TemplateParse.h"
#import "PlainTextSegment.h"
#import "VariableSegment.h"

#pragma mark - Helper functions

#pragma mark - SPEC
SPEC_BEGIN(TemplateParseSpec)

describe(@"TemplateParseSpec", ^{
    
    __block NSString *testString;
    __block TemplateParse *parse;
    __block NSArray *segments;
    afterEach(^{
        testString = nil;
        parse = nil;
        segments = nil;
    });
    context(@"given an empty template", ^{
        beforeEach(^{
            testString = @"";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parseIntoSegments];
        });
        it (@"has only 1 segment", ^{
            [[theValue([segments count]) should] equal:theValue(1)];
        });
        it (@"the first segment is a PlainTextSegmentd", ^{
            [[segments[0] should] beKindOfClass:[PlainTextSegment class]];
        });
    });
    context(@"given a plain text template: 'plain text only'", ^{
        beforeEach(^{
            testString = @"plain text only";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parseIntoSegments];
        });
        it(@"has only one segment", ^{
            [[theValue([segments count]) should] equal:theValue(1)];
        });
        it (@"the first segment is a PlainTextSegment", ^{
            [[segments[0] should] beKindOfClass:[PlainTextSegment class]];
        });
    });
    context(@"given a template with multiple variables", ^{
        beforeEach(^{
            testString = @"${a}:${b}:${c}:${d}";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parseIntoSegments];
        });
        it(@"has 7 segments", ^{
            [[theValue([segments count]) should] equal:theValue(7)];
        });
    });
    
    context(@"parsing template into segments!, given the template string: 'a ${b} c ${d}'", ^{
        beforeEach(^{
            testString = @"a ${b} c ${d}";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parseIntoSegments];
        });
        NSArray *expectedSegments = @[[PlainTextSegment segmentWithValue:@"a "],
                                      [VariableSegment segmentWithValue:@"b"],
                                      [PlainTextSegment segmentWithValue:@" c "],
                                      [VariableSegment segmentWithValue:@"d"]];
       it(@"there should be 2 VariableSegments and 2 PlainTest segments", ^{
           [[segments should] containObjectsInArray:expectedSegments];
       });
    });
});
SPEC_END


