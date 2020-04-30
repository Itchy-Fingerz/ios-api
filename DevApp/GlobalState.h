#import <Foundation/Foundation.h>
#import <WrldNav/WrldNav.h>

@interface GlobalState : NSObject
@property (strong)WRLDNavModel* navModel;
@property (strong, nonatomic) WRLDNavModelObserver* observer;
+ (GlobalState*) instance;
@end
