#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDMapView.h"

NS_ASSUME_NONNULL_BEGIN

typedef std::vector<WRLDRoutingPolylineCreateParams> WRLDRoutingPolylineCreateParamsVector;
typedef std::vector<std::pair<int, int>> WRLDStartEndRangePairVector;

@interface WRLDRouteViewAmalgamationHelper : NSObject

+ (NSMutableArray *) CreatePolylines:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams width:(CGFloat)width miterLimit:(CGFloat)miterLimit ndMap:(WRLDMapView*)map;
+ (bool) CanAmalgamate:(const WRLDRoutingPolylineCreateParams&)a with:(const WRLDRoutingPolylineCreateParams&)b;
+ (WRLDStartEndRangePairVector) BuildAmalgamationRanges:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams;
+ (NSArray *) CreateAmalgamatedPolylinesForRange:(const WRLDRoutingPolylineCreateParamsVector&) polylineCreateParams startRange:(const int) rangeStartIndex ndEndRange:(const int) rangeEndIndex width:(CGFloat)width miterLimit:(CGFloat)miterLimit ndMap:(WRLDMapView*)map;
@end

NS_ASSUME_NONNULL_END