#import "WRLDMenuGroupTitleTableViewCell.h"

@implementation WRLDMenuGroupTitleTableViewCell

- (void)populateWith:(NSString *)text
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
}

@end
