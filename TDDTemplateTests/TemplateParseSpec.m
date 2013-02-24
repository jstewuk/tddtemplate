//
//  TemplateParseSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "TemplateParse.h"

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
            segments = [parse parse];
        });
        it (@"has only 1 segment", ^{
            [[theValue([segments count]) should] equal:theValue(1)];
        });
        it (@"the first segment is ''", ^{
            [[segments[0] should] beIdenticalTo:@""];
        });
    });
    context(@"given a plain text template: 'plain text only'", ^{
        beforeEach(^{
            testString = @"plain text only";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parse];
        });
        it(@"has only one segment", ^{
            [[theValue([segments count]) should] equal:theValue(1)];
        });
        it (@"the first segment is 'plain text only'", ^{
            [[segments[0] should] beIdenticalTo:@"plain text only"];
        });
    });
    context(@"given a template with multiple variables", ^{
        beforeEach(^{
            testString = @"${a}:${b}:${c}:${d}";
            parse = [[TemplateParse alloc] initWithString:testString];
            segments = [parse parse];
        });
        it(@"has 7 segments", ^{
            [[theValue([segments count]) should] equal:theValue(7)];
        });
    });
});
SPEC_END


