#import "WrldPoiSearchService.h"

@interface WrldPoiSearchService () <WRLDMapViewDelegate,WRLDNavSearchProviderProtocol>
{
    WRLDNavSearchProvider *m_wrldNavSearchProvider;
    WRLDNavSuggestionProvider *m_wrldNavSuggestionProvider;
    WRLDPoiService *m_poiService;
    int m_poiSearchId;
    WRLDPoiSearch *m_autoCompleteSearch;
}
@end

@implementation WrldPoiSearchService

- (id) initWithWrldPoiService:(WRLDPoiService*) poiService wrldNavSearchProvider:(WRLDNavSearchProvider*) wrldSearchProvider wrldNavSuggestionProvider:(WRLDNavSuggestionProvider*)suggestionProvider
{
    if((self = [super init]))
    {
        m_wrldNavSearchProvider = wrldSearchProvider;
        [m_wrldNavSearchProvider setSearchProviderDelegate:self];
        m_wrldNavSuggestionProvider = suggestionProvider;
        [m_wrldNavSuggestionProvider setSuggestionProviderDelegate:self];
        m_poiService = poiService;
        m_poiSearchId = 0;
    }
    return self;
}

- (void) UpdateResults:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse *)poiSearchResponse
{
    NSMutableArray *widgetSearchResults = [[NSMutableArray alloc]init];
    NSMutableArray *searchResults  = poiSearchResponse.results;
    
    for(int i = 0; i < searchResults.count; i++)
    {
        WRLDNavSearchResultModel* widgetSearchResult =  [[WRLDNavSearchResultModel alloc] init];
        WRLDPoiSearchResult *result = [searchResults objectAtIndex:i];
        
        widgetSearchResult.title = result.title;
        widgetSearchResult.subTitle = result.subtitle;
        widgetSearchResult.index  = i;
        widgetSearchResult.latLng = result.latLng;
        NSArray *tags = [result.tags componentsSeparatedByString:@" "];
        if (tags.count>=0)
        {
            widgetSearchResult.iconKey = [tags objectAtIndex:0];
        }
        if (![result.indoorMapId isEqualToString:@""])
        {
            widgetSearchResult.indoorMapId = result.indoorMapId;
        }
        widgetSearchResult.indoorMapFloorId = result.indoorMapFloorId;
        
        [widgetSearchResults addObject: widgetSearchResult];
        
    }
    if (m_autoCompleteSearch != nil)
    {
        [m_wrldNavSuggestionProvider receivedSuggestionsWithSuccess:poiSearchResponse.succeeded results:widgetSearchResults];
        m_autoCompleteSearch = nil;
    }
    else
    {
        [m_wrldNavSearchProvider receivedWithSuccess:poiSearchResponse.succeeded results:widgetSearchResults];
    }
}

- (void)perfromSearch:(WRLDSearchRequest * _Nonnull)query
{
    WRLDTextSearchOptions* textSearchOptions = [[WRLDTextSearchOptions alloc] init];
    NSString *queryString = [query.queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    [textSearchOptions setQuery: queryString];
    m_poiSearchId = [[m_poiService searchText: textSearchOptions] poiSearchId];
}

-(void)performAutoCompleteSearch:(WRLDSearchRequest *)query
{
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    NSString *queryString = [query.queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    [autocompleteOptions setQuery: queryString];
    m_autoCompleteSearch = [m_poiService searchAutocomplete:autocompleteOptions] ;
}

-(void)cancelAutoCompleteSearch
{
    if (m_autoCompleteSearch != nil)
    {
        [m_autoCompleteSearch cancel];
        m_autoCompleteSearch = nil;
    }
}

@end
