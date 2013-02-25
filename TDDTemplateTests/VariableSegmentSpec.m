//
//  VariableSegmentSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "VariableSegment.h"

#pragma mark - Helper functions

#pragma mark - SPEC
SPEC_BEGIN(VariableSegmentSpec)

describe(@"Variable Segment", ^{
    __block NSString *key;
    __block NSString *value;
    context(@"given the key 'myKey' and the value 'myValue'" , ^{
        beforeEach(^{
            key = @"myKey";
            value = @"myValue";
        });
        afterEach(^{
            key = value = nil;
        });
        it (@"evaluates to 'myValue'", ^{
            VariableSegment *segment = [VariableSegment segmentWithValue:key];
            [[[segment evaluateWithVariables:@{key : value} error:nil] should] equal:@"myValue"];
        });
    });
    context(@"given a key 'keyWitnNoValue' and no value", ^{
        beforeEach(^{
            key = @"keyWithNoValue";
            value = nil;
        });
        afterEach(^{
            key = value = nil;
        });
        it(@"evaluate returns nil and an error", ^{
            NSError *error;
            VariableSegment *segment = [VariableSegment segmentWithValue:key];
            [[segment evaluateWithVariables:@{@"notUsed" : @"notNeeded"} error:&error] shouldBeNil];
            [error shouldNotBeNil];
        });
    });
});
SPEC_END


