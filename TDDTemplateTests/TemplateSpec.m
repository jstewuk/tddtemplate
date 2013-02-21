//
//  TestSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "Template.h"


SPEC_BEGIN(TemplateSpec)
describe(@"Template", ^{
    context(@"with  template '${one}, ${two}, ${three}'", ^{
        __block Template *template = nil;
        beforeEach(^{
            template = [[Template alloc] initWithString:@"${one}, ${two}, ${three}"];
            [template addVariable:@"one" withValue:@"1"];
            [template addVariable:@"three" withValue:@"3"];
        });
        afterEach(^{
            template = nil;
        });
        context(@"with values '1', '2' and '3'", ^{
            beforeEach(^{
                 [template addVariable:@"two" withValue:@"2"];
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
                [template addVariable:@"two" withValue:@"${foo}"];
            });
            it(@"results in the string '1, ${foo}, 3'", ^{
                [[[template evaluate] should] equal:@"1, ${foo}, 3"];
            });
        });
    });
    context(@"with  template 'Hello, ${name}', with no value for 'name'", ^{
        Template *template = [[Template alloc] initWithString:@"Hello, ${name}"];
        it(@"returns a nil string", ^{
            [[template evaluate] shouldBeNil];
        });
    });
});
SPEC_END


