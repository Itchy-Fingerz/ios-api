#import "GlobalState.h"

#include <stdlib.h>

@interface GlobalState () <WRLDNavModelObserverProtocol>

@end

@implementation GlobalState

static GlobalState* shared = NULL;

- (id)init
{
    if((self = [super init]))
    {
        _navModel = [[WRLDNavModel alloc] init];
        
        _observer = [[WRLDNavModelObserver alloc] init];
        [_observer setDelegate:self];
        
        [_observer registerObserver:@"route"];
        [_observer setNavModel:_navModel];
        
//        [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                         target:self
//                                       selector:@selector(timerCallback:)
//                                       userInfo:nil
//                                        repeats:YES];
    }
    return self;
}

+ (GlobalState*) instance
{
    @synchronized(shared)
    {
        if(!shared || shared==NULL)
        {
            shared = [[GlobalState alloc] init];
        }
        return shared;
    }
}

- (void) timerCallback:(NSTimer *)timer
{
    NSInteger duration = [[_navModel route] estimatedRouteDuration];
    if(duration<0)
        duration = 1;
    NSInteger remaining = [_navModel remainingRouteDuration];
    NSUInteger count = [[[_navModel route] directions] count];
    remaining = ([_navModel navMode] == WRLDNavModeActive)?((remaining<1)?0:remaining-1):duration;
    [_navModel setRemainingRouteDuration:remaining];
    
    NSInteger currentDirection = (count)-((remaining * count) / duration);
    if(currentDirection>0)
        currentDirection--;
    [_navModel setCurrentDirectionIndex:currentDirection];
}

- (void) changeReceived:(NSString *)keyPath
{
    if([keyPath isEqualToString:@"route"])
    {
        if ([_navModel route]!=nil)
        {
            [_navModel setRemainingRouteDuration: [[_navModel route] estimatedRouteDuration]];
            _navModel.navMode = WRLDNavModeReady;
        }
        else
        {
            [_navModel setRemainingRouteDuration: 0];
            _navModel.navMode = WRLDNavModeNotReady;
        }
    }
}

- (void) eventReceived: (WRLDNavEvent)key
{
    switch(key)
    {
        case WRLDNavEventStartEndButtonClicked:
        {
            WRLDNavMode navMode = [_navModel navMode];
            switch(navMode)
            {
                case WRLDNavModeNotReady:
                    break;
                case WRLDNavModeReady:
                    [_navModel setNavMode:WRLDNavModeActive];
                    break;
                case WRLDNavModeActive:
                    [_navModel setNavMode:WRLDNavModeReady];
                    break;
            }
            
            break;
        }
        case WRLDNavEventCloseSetupJourneyClicked:
            [_navModel sendNavEvent:WRLDNavEventWidgetAnimateOut];
            break;
        case WRLDNavEventStartLocationClearButtonClicked:
            [_navModel setStartLocation:nil];
            break;
        case WRLDNavEventEndLocationClearButtonClicked:
            [_navModel setEndLocation:nil];
            break;
            
        default:
            break;
    }
}

@end
