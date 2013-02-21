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
    context(@"with template 'Hello, ${name}, with the value 'Reader' for variable 'name'", ^{
        Template *template = [[Template alloc] initWithString:@"Hello, ${name}"];
        [template addVariable:@"name" withValue:@"Reader"];
        it(@"results in the string 'Hello, Reader'", ^{
            [[[template evaluate] should] equal:@"Hello, Reader"];
        });
    });
    context(@"with template 'Hi, ${name}, with the value 'not Reader' for variable 'name'", ^{
        Template *template = [[Template alloc] initWithString:@"Hi, ${name}"];
        [template addVariable:@"name" withValue:@"not Reader"];
        it(@"results in the string 'Hi, not Reader'", ^{
            [[[template evaluate] should] equal:@"Hi, not Reader"];
        });
    });
    context(@"with  template '${one}, ${two}, ${three}', values '1', '2' and '3'", ^{
        Template *template = [[Template alloc] initWithString:@"${one}, ${two}, ${three}"];
        [template addVariable:@"one" withValue:@"1"];
        [template addVariable:@"two" withValue:@"2"];
        [template addVariable:@"three" withValue:@"3"];
        it(@"results in the string '1, 2, 3'", ^{
            [[[template evaluate] should] equal:@"1, 2, 3"];
        });
    });
    context(@"with  template '${one}, ${two}, ${three}', values '1', '${foo}' and '3'", ^{
        Template *template = [[Template alloc] initWithString:@"${one}, ${two}, ${three}"];
        [template addVariable:@"one" withValue:@"1"];
        [template addVariable:@"two" withValue:@"${foo}"];
        [template addVariable:@"three" withValue:@"3"];
        it(@"results in the string '1, 2, 3'", ^{
            [[[template evaluate] should] equal:@"1, ${foo}, 3"];
        });
    });
    context(@"with  template 'Hello, ${name}', with no value for 'name'", ^{
        Template *template = [[Template alloc] initWithString:@"Hello, ${name}"];
        pending(@"returns a nil string", ^{
            [[template evaluate] shouldBeNil];
        });
    });
    context(@"with  template 'Hello, ${name}', with values 'Hi' and 'Reader' for variables 'doesnotexist' and 'name'", ^{
        Template *template = [[Template alloc] initWithString:@"Hello, ${name}"];
        [template addVariable:@"doesnotexist" withValue:@"Hi"];
        [template addVariable:@"name" withValue:@"Reader"];
        it(@"results in the string 'Hello, Reader'", ^{
            [[[template evaluate] should] equal:@"Hello, Reader"];
        });
    });
});
SPEC_END


