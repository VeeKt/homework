//
//  ViewControllerSecond.m
//  CoreData
//
//  Created by user2 on 19.01.18.
//  Copyright © 2018 user2. All rights reserved.
//

#import "ViewControllerSecond.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"

CGFloat fieldViewOffset = 50;
CGFloat widthFieldOffset = 10;

@interface ViewControllerSecond ()

@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;
@property (nonatomic, strong) UITextField *name;
@property (nonatomic, strong) UITextField *surName;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewControllerSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"New person";
    self.view.backgroundColor = [UIColor grayColor];
    
#pragma mark - button
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(onButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Add Person" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(2 * widthFieldOffset, CGRectGetHeight(self.view.frame) - 2 * fieldViewOffset, CGRectGetWidth(self.view.frame) - 4 * widthFieldOffset, fieldViewOffset);
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    
#pragma mark - fields
    
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(widthFieldOffset, 2 * fieldViewOffset, CGRectGetWidth(self.view.frame) - 2 * widthFieldOffset, fieldViewOffset)];
    self.name.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.name];
    
    self.surName = [[UITextField alloc] initWithFrame:CGRectMake(widthFieldOffset, 3 * fieldViewOffset + widthFieldOffset, CGRectGetWidth(self.view.frame) - 2 * widthFieldOffset, fieldViewOffset)];
    self.surName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.surName];
}

#pragma mark - button action

- (void)onButtonClickAction:(UIButton *)sender {
    if ([self.name.text length] != 0 || [self.surName.text length] != 0) {
        [self coreDataSaveText];
        NSLog(@"Save name %@, surname %@", self.name, self.surName);
        self.name.text = @"";
        self.surName.text = @"";
    } else {
        NSLog(@"Try again! Empty person's info!");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - core data

- (NSManagedObjectContext *)coreDataContext {
    if (_coreDataContext) {
        return _coreDataContext;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    NSPersistentContainer *container = ((AppDelegate *)(application.delegate)).
    persistentContainer;
    NSManagedObjectContext *context = container.viewContext;
    
    return context;
}

- (void)coreDataSaveText {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.coreDataContext];
    person.name = self.name.text;
    person.surName = self.surName.text;
    
    NSError *error = nil;
    if (![person.managedObjectContext save:&error]) {
        NSLog(@"Failed saving object");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    error = nil;
    NSArray *result = [self.coreDataContext executeFetchRequest:[Person fetchRequest] error:&error];
    NSLog(@"result - %@", result);
}

@end


