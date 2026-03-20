#import <UIKit/UIKit.h>

@interface DYYYColorPickerViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *presetColors;
@property (nonatomic, strong) NSString *selectedColorScheme;
@property (nonatomic, copy) void (^colorSelectedHandler)(NSString *colorScheme);
@property (nonatomic, assign) BOOL isDarkMode;

@end
