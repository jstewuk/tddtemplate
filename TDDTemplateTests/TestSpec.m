//
//  TestSpec.m
//  TDDTemplate
//
//  Created by James Stewart on 2/20/13.
//  Copyright 2013 StewartStuff. All rights reserved.
//

#import <Kiwi/Kiwi.h>


SPEC_BEGIN(TestSpec)
describe(@"Test Kiwi Setup", ^{
    context(@"with Kiwi cocoapod installed", ^{
        beforeEach(^{
        });
        afterEach(^{
        });
        it(@"a trivial test should pass", ^{
            [[theValue(2) should] equal:theValue(2)];
        });
    });
});
SPEC_END


