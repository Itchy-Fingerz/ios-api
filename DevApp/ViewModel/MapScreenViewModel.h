#import <Foundation/Foundation.h>
#import "WrldPoiSearchService.h"

@import WrldNavWrld;

NS_ASSUME_NONNULL_BEGIN

@interface MapScreenViewModel : NSObject
{
    
}
-(instancetype) initWith:(WRLDMapView *) mapView;
-(WrldPoiSearchService*)getMapSearchProvider;
-(WRLDNavSearchWidget*)getNavSearchWidget;
@end

NS_ASSUME_NONNULL_END
