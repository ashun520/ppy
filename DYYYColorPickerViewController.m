#import "DYYYColorPickerViewController.h"

@interface DYYYColorPickerViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *customColors;
@property (nonatomic, strong) UITextField *customColorField;
@end

@implementation DYYYColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全局文字颜色";
    self.view.backgroundColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    
    [self loadCustomColors];
    [self setupPresetColors];
    [self setupTableView];
    [self setupCustomColorInput];
}

- (void)loadCustomColors {
    self.customColors = [[NSUserDefaults standardUserDefaults] arrayForKey:@"DYYYSavedCustomColors"] ?: [NSMutableArray array];
}

- (void)saveCustomColors {
    [[NSUserDefaults standardUserDefaults] setObject:self.customColors forKey:@"DYYYSavedCustomColors"];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)setupCustomColorInput {
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    inputView.backgroundColor = self.isDarkMode ? [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width - 30, 20)];
    label.text = @"自定义颜色（十六进制）";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = self.isDarkMode ? [UIColor whiteColor] : [UIColor blackColor];
    [inputView addSubview:label];
    
    self.customColorField = [[UITextField alloc] initWithFrame:CGRectMake(15, 35, self.view.bounds.size.width - 100, 40)];
    self.customColorField.placeholder = @"#RRGGBB 或 #RRGGBB,#RRGGBB";
    self.customColorField.font = [UIFont systemFontOfSize:15];
    self.customColorField.borderStyle = UITextBorderStyleRoundedRect;
    self.customColorField.delegate = self;
    self.customColorField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.customColorField.autocorrectionType = UITextAutocorrectionTypeNo;
    [inputView addSubview:self.customColorField];
    
    UIButton *previewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 75, 35, 60, 40)];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    previewButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0];
    [previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    previewButton.layer.cornerRadius = 5;
    [previewButton addTarget:self action:@selector(previewCustomColor) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:previewButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 80, self.view.bounds.size.width - 30, 15)];
    [saveButton setTitle:@"保存到自定义列表" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveButton addTarget:self action:@selector(saveCustomColor) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:saveButton];
    
    [self.view addSubview:inputView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presetColors.count + self.customColors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ColorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *colorInfo;
    if (indexPath.row < self.presetColors.count) {
        colorInfo = self.presetColors[indexPath.row];
    } else {
        colorInfo = self.customColors[indexPath.row - self.presetColors.count];
    }
    
    cell.textLabel.text = colorInfo[@"name"];
    cell.detailTextLabel.text = colorInfo[@"scheme"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *colorInfo;
    if (indexPath.row < self.presetColors.count) {
        colorInfo = self.presetColors[indexPath.row];
    } else {
        colorInfo = self.customColors[indexPath.row - self.presetColors.count];
    }
    NSString *colorScheme = colorInfo[@"scheme"];
    
    if (self.colorSelectedHandler) {
        self.colorSelectedHandler(colorScheme);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)previewCustomColor {
    NSString *inputColor = self.customColorField.text;
    if (![self validateColorFormat:inputColor]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"格式错误" message:@"请输入有效的十六进制颜色代码\n格式：#RRGGBB 或 #RRGGBB,#RRGGBB" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.colorSelectedHandler) {
        self.colorSelectedHandler(inputColor);
    }
    
    UIAlertController *preview = [UIAlertController alertControllerWithTitle:@"预览效果" message:[NSString stringWithFormat:@"颜色方案：%@\n已应用，部分文字可能需要重新加载", inputColor] preferredStyle:UIAlertControllerStyleAlert];
    [preview addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:preview animated:YES completion:nil];
}

- (void)saveCustomColor {
    NSString *inputColor = self.customColorField.text;
    if (![self validateColorFormat:inputColor]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"格式错误" message:@"请输入有效的十六进制颜色代码" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *colorName = [NSString stringWithFormat:@"自定义颜色 %@", inputColor];
    NSDictionary *customColor = @{@"name": colorName, @"scheme": inputColor};
    [self.customColors addObject:customColor];
    [self saveCustomColors];
    
    [self.tableView reloadData];
    
    UIAlertController *saved = [UIAlertController alertControllerWithTitle:@"保存成功" message:@"自定义颜色已保存到列表" preferredStyle:UIAlertControllerStyleAlert];
    [saved addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:saved animated:YES completion:nil];
    
    self.customColorField.text = @"";
}

- (BOOL)validateColorFormat:(NSString *)colorString {
    if (!colorString || colorString.length == 0) {
        return NO;
    }
    
    NSArray *colors = [colorString componentsSeparatedByString:@","];
    if (colors.count == 0 || colors.count > 5) {
        return NO;
    }
    
    NSRegularExpression *hexPattern = [NSRegularExpression regularExpressionWithPattern:@"^#([0-9A-Fa-f]{6})$" options:0 error:nil];
    
    for (NSString *color in colors) {
        NSString *trimmedColor = [color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![hexPattern matchesInString:trimmedColor options:0 range:NSMakeRange(0, trimmedColor.length)]) {
            return NO;
        }
    }
    
    return YES;
}

@end
