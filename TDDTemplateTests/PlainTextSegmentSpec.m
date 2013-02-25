//
//  PlainTextSegmentSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "PlainTextSegment.h"

#pragma mark - Helper functions

#pragma mark - SPEC
SPEC_BEGIN(PlainTextSegmentSpec)

describe(@"Plain Text Segment", ^{
    __block NSString *testString;
    context(@"given the string: 'abc def'" , ^{
        beforeEach(^{
            testString = @"abc def";
        });
        afterEach(^{
            testString = nil;
        });
        
        it (@"evaluates to 'abc def'", ^{
            PlainTextSegment *segment = [PlainTextSegment segmentWithValue:testString];
            [[[segment evaluateWithVariables:nil error:nil] should] equal:@"abc def"];
        });
    });
});
SPEC_END


