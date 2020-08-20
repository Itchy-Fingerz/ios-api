#pragma once

#import <Foundation/Foundation.h>

#import "WRLDMapView.h"
#import "WRLDRoute.h"
#import "WRLDPolyline.h"
#import "WRLDRouteStep.h"
#import "WRLDRouteViewOptions.h"


NS_ASSUME_NONNULL_BEGIN


@interface WRLDRouteView : NSObject

/*!
 * Create a new RouteView for the given route and options, and add it to the map.
 *
 * @param map The WRLDMapView to draw this RouteView on.
 * @param route The Route to display.
 * @param options Options for styling the route.
 */
- (instancetype)initWithMapView:(WRLDMapView*)map
                           route:(WRLDRoute*)route
                          options:(WRLDRouteViewOptions*)options;
/*!
 * Add this RouteView back on to the map, if it has been removed.
 */
- (void) addToMap;

- (WRLDPolyline*) makeVerticalLine:(WRLDRouteStep*)step
                             floor:(NSInteger)floor
                            height:(CGFloat)height;

- (void) addLinesForRouteStep:(WRLDRouteStep*)step;

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter;

/*!
 * Update the progress of turn by turn navigation on route.
 *
 * @param sectionIndex The current index of WRLDRouteSection.
 * @param stepIndex The current index of WRLDRouteStep.
 * @param closestPointOnPath Closest point on the path of WRLDRouteStep.
 * @param indexOfPathSegmentStartVertex Index of path segment start vertex in WRLDRouteStep.
 */

-(void) updateRouteProgress:(int)sectionIndex
                  stepIndex:(int)stepIndex
         closestPointOnPath:(CLLocationCoordinate2D)closestPointOnPath
indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex;

/*!
 * Remove this RouteView from the map.
 */
- (void) removeFromMap;

/*!
 * Sets the width of this RouteView's polylines.
 *
 * @param width The width of the polyline in screen pixels.
 */
- (void) setWidth:(CGFloat)width;

/*!
 * Sets the color for this RouteView's polylines.
 *
 * @param color The color of the polyline as a 32-bit ARGB color.
 */
- (void) setColor:(UIColor*)color;

/*!
 * Sets the miter limit of this RouteView's polylines.
 *
 * @param miterLimit The miter limit, as a ratio between maximum allowed miter join diagonal
 *                   length and the line width.
 */
- (void) setMiterLimit:(CGFloat)miterLimit;

@end

NS_ASSUME_NONNULL_END
