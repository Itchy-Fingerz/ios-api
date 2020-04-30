#import <Foundation/Foundation.h>
@import Wrld;
@import WRLDSearchWidget;
@import WrldNavSearch;

@interface WrldPoiSearchService : NSObject

- (id) initWithWrldPoiService:(WRLDPoiService*) poiService wrldNavSearchProvider:(WRLDNavSearchProvider*) wrldSearchProvider wrldNavSuggestionProvider:(WRLDNavSuggestionProvider*)suggestionProvider;
- (void) UpdateResults:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse*) poiSearchResponse;

@end
