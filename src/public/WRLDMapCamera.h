#pragma once

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// An object representing a view of the map.
@interface WRLDMapCamera : NSObject <NSSecureCoding, NSCopying>

/*!
 Initialize a camera instance.

 @returns A WRLDMapCamera instance.
 */
+ (instancetype)camera;

/*!
 Instantiate a camera at a location, looking towards a center coordinate.
 @param centerCoordinate Coordinate to center the view on.
 @param eyeCoordinate The coordinate the camera should be placed at.
 @param eyeAltitude The distance above sea-level the camera should be looking from.
 @returns A WRLDMapCamera instance.
 */
+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                              fromEyeCoordinate:(CLLocationCoordinate2D)eyeCoordinate
                                    eyeAltitude:(CLLocationDistance)eyeAltitude;

/*!
 Instantiate a camera with a center, distance, pitch, and heading.
 @param centerCoordinate Coordinate to center the view on.
 @param distance The distance of the camera from the centerCoordinate.
 @param pitch The pitch angle in degrees relative to a top-down view.
 @param heading The heading direction of the map.
 @returns A WRLDMapCamera instance.
 */
+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                   fromDistance:(CLLocationDistance)distance
                                          pitch:(CGFloat)pitch
                                        heading:(CLLocationDirection)heading;

/// The coordinate around which the map is centered.
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/// The heading direction of the map.
@property (nonatomic) CLLocationDirection heading;

/// The pitch angle in degrees relative to a top-down view.
@property (nonatomic) CGFloat pitch;

/// The distance of the camera from the center coordinate.
@property (nonatomic) CLLocationDistance distance;

/// The altitude of the camera relative to sea-level.
- (CLLocationDistance)altitude;

@end

NS_ASSUME_NONNULL_END
