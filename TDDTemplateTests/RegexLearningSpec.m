//
//  RegexLearningSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#pragma mark - Helper functions

#pragma mark - SPEC
SPEC_BEGIN(RegexLearningSpec)

describe(@"Learning Regex", ^{
    context(@"given the string: '${a}:${b}:${c}:${d}' and pattern '\\$\\{.+?\\}'", ^{
        NSString *testString = @"${a}:${b}:${c}:${d}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{.+?\\}" options:0 error:nil];
        afterEach(^{
        });
        context(@"matchesInString:Options:Range:", ^{
            __block NSArray *matches;
            beforeEach(^{
                matches = [regex matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
            });
            afterEach(^{
                matches = nil;
            });
            
            it (@"returns an array with the first matched range: (0, 4)", ^{
                NSTextCheckingResult *textChkResult = matches[0];
                [[theValue(textChkResult.range.location) should] equal:theValue(0)];
                [[theValue(textChkResult.range.length) should] equal:theValue(4)];
            });
            it (@"and a second matched range: (5, 4)", ^{
                NSTextCheckingResult *textChkResult = matches[1];
                [[theValue(textChkResult.range.location) should] equal:theValue(5)];
                [[theValue(textChkResult.range.length) should] equal:theValue(4)];
            });
            it (@"only has 4 matched ranges", ^{
                [[theValue([matches count]) should] equal:theValue(4)];
            });
        });
        
    });
});
SPEC_END


