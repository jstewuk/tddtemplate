//
//  TestSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "Template.h"

#pragma mark - Helper functions
NSArray *genVariables() {
    NSMutableArray *variables = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < 20; i++) {
        NSString *key = [NSString stringWithFormat:@"var%d", i];
        NSString *value = [NSString stringWithFormat:@"A long string for val%d ", i];
        [variables addObject:@{key : value}];
    }
    return variables;
}

NSString *genTemplateString(NSArray* variables) {
    NSArray *words = @[@"a ", @"quick ", @"blah ", @"brown fox ", @"is my friend ", @"and I will revell "];
    
    NSMutableString *templateString = [NSMutableString string];
    for (int wordsIndex = 0; wordsIndex < 100; wordsIndex ++) {
        [templateString appendString:words[random()%6]];
        if (wordsIndex % 5 == 0) {
            NSString *varToAppend = [NSString stringWithFormat:@"${%@} ",[[variables[random() % 20] allKeys] lastObject]];
            [templateString appendString:varToAppend];
        }
    }
    return templateString;
}


#pragma mark - SPEC
SPEC_BEGIN(TemplateSpec)

describe(@"Template", ^{
    __block Template *template = nil;
    afterEach(^{
        template = nil;
    });
    context(@"'${one}, ${two}, ${three}'", ^{
        beforeEach(^{
            template = [[Template alloc] initWithString:@"${one}, ${two}, ${three}"];
        });
        context(@"with values '1', '2' and '3'", ^{
            beforeEach(^{
                [template addVariable:@"one" withValue:@"1"];
                [template addVariable:@"two" withValue:@"2"];
                [template addVariable:@"three" withValue:@"3"];
            });
            it(@"results in the string '1, 2, 3'", ^{
                [[[template evaluate] should] equal:@"1, 2, 3"];
            });
            context(@"plus an 'extra' variable", ^{
                beforeEach(^{
                    [template addVariable:@"doesNotExist" withValue:@"noValue"];
                });
                it(@"results in the string '1, 2, 3'", ^{
                    [[[template evaluate] should] equal:@"1, 2, 3"];
                });
            });
        });
        context(@"with values '1', '${foo}, '3''", ^{
            beforeEach(^{
                [template addVariable:@"one" withValue:@"1"];
                [template addVariable:@"two" withValue:@"${foo}"];
                [template addVariable:@"three" withValue:@"3"];
            });
            it(@"results in the string '1, ${foo}, 3'", ^{
                [[[template evaluate] should] equal:@"1, ${foo}, 3"];
            });
        });
    });
    
    context(@"with  template 'Hello, ${name}', with no value for 'name'", ^{
        template = [[Template alloc] initWithString:@"Hello, ${name}"];
        it(@"returns a nil string", ^{
            [[template evaluate] shouldBeNil];
        });
    });
    
    context(@"with 1000 words and 20 variables with values of approximately 15 characters each ", ^{
        beforeEach(^{
            NSArray *variables = genVariables();
            NSString *templateString = genTemplateString(variables);
            
            template = [[Template alloc] initWithString:templateString];
            for (int varIndex = 0; varIndex < 20; varIndex++) {
                NSString *key = [[variables[varIndex] allKeys] lastObject];
                NSString *value = [[variables[varIndex] allValues] lastObject];
                [template addVariable:key withValue:value];
            }
        });
        it(@"rendering took < 200 msec", ^{
            NSDate *start = [NSDate dateWithTimeIntervalSinceNow:0];
            [template evaluate];
            NSTimeInterval time = - [start timeIntervalSinceNow];
            [[theValue(time) should] beLessThan:theValue(0.002)];
        });
    });
});
SPEC_END


