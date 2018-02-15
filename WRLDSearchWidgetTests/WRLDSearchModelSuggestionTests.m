//
//  WRLDSearchModelTests.m
//  WRLDSearchModelTests
//
//  Created by Michael O'Donnell on 08/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#include "WRLDSearchModel.h"
#include "WRLDSuggestionProvider.h"
#include "WRLDSuggestionProvider.h"
#include "WRLDSuggestionProvider.h"
#include "WRLDSuggestionProviderHandle.h"
#include "WRLDSearchQuery.h"
#include "WRLDSearchRequest.h"
#include "WRLDSearchTypes.h"
#include "WRLDSearchQueryObserver.h"

@interface WRLDSearchModelSuggestionTests : XCTestCase

@end

@implementation WRLDSearchModelSuggestionTests
{
    WRLDSearchModel *model;
    NSString* testString;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    model = [[WRLDSearchModel alloc] init];
    testString = @"TestString";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testInitReturnsASearchModel {
    XCTAssertNotNil(model);
}

- (void)testAddingASuggestionProviderReturnsASuggestionProviderReference {
    id mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    WRLDSuggestionProviderHandle * handle = [model addSuggestionProvider:mockProvider];
    XCTAssertNotNil(handle);
}

- (void)testRunningASuggestionQueryReturnsValidObject {
    WRLDSearchQuery *query = [model getSuggestionsForString:testString];
    XCTAssertNotNil(query);
}

- (void)testSuggestionDelegateStartingMethodInvokedOnGetSuggestionsForString
{
    __block BOOL didRunBlock = NO;
    [model.suggestionObserver addQueryStartingEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    [model getSuggestionsForString:testString];
    XCTAssertTrue(didRunBlock);
}

- (void)testQueryCompleteFlagInCorrectStateDuringProviderCompletions {
    
    id<WRLDSuggestionProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    __block WRLDSearchRequest *requestCapture1 = nil;
    id<WRLDSuggestionProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    __block WRLDSearchRequest *requestCapture2 = nil;
    
    OCMStub([mockProvider1 getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture1 = request;
        return YES;
    }]]);
    OCMStub([mockProvider2 getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture2 = request;
        return YES;
    }]]);
    
    [model addSuggestionProvider:mockProvider1];
    [model addSuggestionProvider:mockProvider2];
    WRLDSearchQuery *query = [model getSuggestionsForString:testString];
    XCTAssertFalse(query.hasCompleted);
    [requestCapture1 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertFalse(query.hasCompleted);
    [requestCapture2 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertTrue(query.hasCompleted);
}

- (void)testSearchDelegateCompletionMethodInvokedOnGetSuggestionsForStringWithNoProviders
{
    __block BOOL didRunBlock = NO;
    [model.suggestionObserver addQueryCompletedEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    [model getSuggestionsForString: testString];
    XCTAssertTrue(didRunBlock);
}

- (void)testSearchInvokesCompletionDelegateWhenProvidersComplete {
    
    id<WRLDSuggestionProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model addSuggestionProvider:mockProvider];
    
    __block BOOL didRunBlock = NO;
    [model.suggestionObserver addQueryCompletedEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    
    [model getSuggestionsForString:testString];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertTrue(didRunBlock);
}

- (void)testSuggestionsOnlyInvokesCompletionDelegateWhenAllProvidersComplete {
    
    id<WRLDSuggestionProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    __block WRLDSearchRequest *requestCapture1 = nil;
    id<WRLDSuggestionProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    __block WRLDSearchRequest *requestCapture2 = nil;
    
    OCMStub([mockProvider1 getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture1 = request;
        return YES;
    }]]);
    OCMStub([mockProvider2 getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture2 = request;
        return YES;
    }]]);
    
    [model addSuggestionProvider:mockProvider1];
    [model addSuggestionProvider:mockProvider2];
    
    __block NSInteger numberOfCalls = 0;
    
    [model.suggestionObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        ++numberOfCalls;
    }];
    
    [model getSuggestionsForString:testString];
    [requestCapture1 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    [requestCapture2 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertEqual(numberOfCalls, 1);
}

- (void)testSuggestionsStartingDelegateInvokedBeforeCompletionDelegateOnGetSearchResultsForStringWithNoProviders
{
    __block BOOL didRunStartBlock = NO;
    __block BOOL didRunCompletedBlock = NO;
    
    [model.suggestionObserver addQueryStartingEvent:^(WRLDSearchQuery *query) {
        didRunStartBlock = YES;
        XCTAssertFalse(didRunCompletedBlock);
    }];
    [model.suggestionObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        didRunCompletedBlock = YES;
        XCTAssertTrue(didRunStartBlock);
    }];
    [model getSuggestionsForString:testString];
    XCTAssertTrue(didRunStartBlock);
    XCTAssertTrue(didRunCompletedBlock);
}

- (void)testASuggestionQueryWithZeroProvidersIsComplete {
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertEqual([query progress], Completed);
}

- (void)testAnIncompleteSuggestionQueryReturnsNilResults {
    id<WRLDSuggestionProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    WRLDSuggestionProviderHandle * providerHandle = [model addSuggestionProvider:mockProvider];
    WRLDSearchQuery *query = [model getSuggestionsForString:testString];
    XCTAssertNil([query getResultsForFulfiller: providerHandle.identifier]);
}

- (void)testSuggestionProviderHandleNotNil {
    id<WRLDSuggestionProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    WRLDSuggestionProviderHandle* handle = [model addSuggestionProvider:mockProvider];
    XCTAssertNotNil(handle.provider);
}

- (void)testRunningASuggestionQueryDispatchesToOnlyRegisteredSuggestionProvider {
    id<WRLDSuggestionProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    [model addSuggestionProvider:mockProvider];
    [model getSuggestionsForString:testString];
    OCMVerify([mockProvider getSuggestions:[OCMArg any]]);
}

- (void)testRunningASuggestionQueryDispatchesToAllRegisteredSuggestionProviders {
    id<WRLDSuggestionProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    id<WRLDSuggestionProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    [model addSuggestionProvider:mockProvider1];
    [model addSuggestionProvider:mockProvider2];
    [model getSuggestionsForString:testString];
    OCMVerify([mockProvider1 getSuggestions:[OCMArg any]]);
    OCMVerify([mockProvider2 getSuggestions:[OCMArg any]]);
}

- (void)testQueryDispatchedToSuggestionProvidersMatchesRunQuery {
    id<WRLDSuggestionProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    [model addSuggestionProvider:mockProvider];
    WRLDSearchQuery *query = [model getSuggestionsForString:testString];
    OCMVerify([mockProvider getSuggestions:[OCMArg checkWithBlock:^BOOL(WRLDSearchQuery * providerQuery){
        return providerQuery.queryString == query.queryString;
    }]]);
}

- (void)testRunningASuggestionQueryDoesNotDispatchToRemovedSuggestionProviders {
    id<WRLDSuggestionProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    id<WRLDSuggestionProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    [model addSuggestionProvider:mockProvider1];
    WRLDSuggestionProviderHandle * mockProvider2Handle = [model addSuggestionProvider:mockProvider2];
    [model removeSuggestionProvider:mockProvider2Handle];
    [model getSuggestionsForString:testString];
    OCMVerify([mockProvider1 getSuggestions:[OCMArg any]]);
    OCMReject([mockProvider2 getSuggestions:[OCMArg any]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
