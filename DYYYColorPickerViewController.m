#import "DYYYColorPickerViewController.h"

@interface DYYYColorPickerViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation DYYYColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全局文字颜色";
    self.view.backgroundColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    
    [self setupPresetColors];
    [self setupTableView];
}

- (void)setupPresetColors {
    self.presetColors = @[
        @{@"name": @"纯白色", @"scheme": @"#FFFFFF"},
        @{@"name": @"纯黑色", @"scheme": @"#000000"},
        @{@"name": @"红色渐变", @"scheme": @"#FF0000,#FF4444"},
        @{@"name": @"蓝色渐变", @"scheme": @"#0066FF,#00CCFF"},
        @{@"name": @"绿色渐变", @"scheme": @"#00FF00,#00FF88"},
        @{@"name": @"紫色渐变", @"scheme": @"#9900FF,#CC66FF"},
        @{@"name": @"橙色渐变", @"scheme": @"#FF6600,#FFAA00"},
        @{@"name": @"粉色渐变", @"scheme": @"#FF66B2,#FF99D6"},
        @{@"name": @"青色渐变", @"scheme": @"#00FFFF,#66FFFF"},
        @{@"name": @"黄金渐变", @"scheme": @"#FFD700,#FFA500"},
        @{@"name": @"彩虹渐变", @"scheme": @"rainbow"},
        @{@"name": @"动态彩虹", @"scheme": @"rainbow_rotating"},
        @{@"name": @"火焰渐变", @"scheme": @"#FF0000,#FF4500,#FF8C00,#FFD700"},
        @{@"name": @"海洋渐变", @"scheme": @"#001F3F,#0074D9,#7FDBFF,#39CCCC"},
        @{@"name": @"森林渐变", @"scheme": @"#2ECC40,#01FF70,#3D9970,#008080"},
        @{@"name": @"日落渐变", @"scheme": @"#FF416C,#FF4B2B,#FF9068"},
        @{@"name": @"星空渐变", @"scheme": @"#0F0C29,#302B63,#24243E"},
        @{@"name": @"薄荷渐变", @"scheme": @"#00B09B,#96C93D"},
        @{@"name": @"薰衣草渐变", @"scheme": @"#DA22FF,#9733EE"},
        @{@"name": @"珊瑚渐变", @"scheme": @"#FF9A9E,#FECFEF"}
    ];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presetColors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ColorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *colorInfo = self.presetColors[indexPath.row];
    cell.textLabel.text = colorInfo[@"name"];
    cell.detailTextLabel.text = colorInfo[@"scheme"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *colorInfo = self.presetColors[indexPath.row];
    NSString *colorScheme = colorInfo[@"scheme"];
    
    if (self.colorSelectedHandler) {
        self.colorSelectedHandler(colorScheme);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
