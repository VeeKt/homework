//
//  ViewController.m
//  CoreData
//
//  Created by user2 on 19.01.18.
//  Copyright © 2018 user2. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewControllerSecond.h"
#import "Person+CoreDataClass.h"


CGFloat tableViewOffset = 70;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSArray *personsArray;
@property (nonatomic, strong) UITableView *personsTableView;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@property NSUInteger rowNo;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadModel];
    
    [self createUI];
    
//    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] init];
//    self.fetchedResultsController willChange:<#(NSKeyValueChange)#> valuesAtIndexes:<#(nonnull NSIndexSet *)#> forKey:<#(nonnull NSString *)#>
    
}


- (void)createUI {
    self.title = @"List of persons";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.personsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2 * tableViewOffset, CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.view.frame) - 2 * tableViewOffset) style:UITableViewStylePlain];
    self.personsTableView.delegate = self;
    self.personsTableView.dataSource = self;
    self.personsTableView.allowsMultipleSelectionDuringEditing = NO;
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, tableViewOffset, CGRectGetWidth(self.view.frame), tableViewOffset)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.personsTableView];
    
    
    self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(pushSecondController)];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
}

- (void)pushSecondController {
    ViewControllerSecond *secondViewController = [[ViewControllerSecond alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personInfo"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"personInfo"];
    }
    
    Person *person = self.personsArray[indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.surName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personsArray.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.coreDataContext deleteObject:managedObject];
        [self.coreDataContext save:nil];
    }
}


#pragma mark - workWithModel

- (void)loadModel {
    self.personsArray = nil;
    self.personsArray = [self.coreDataContext executeFetchRequest:[Person fetchRequest] error:nil];
}

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

// удаление из таблицы и апгрейт + логгирование, что объект удален
// чтобы не крашилось

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.rowNo = indexPath.row;
}

-(NSArray *)deletePersonFromTable {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@", self.rowNo];
    NSArray *newPersonsArray = [self.personsArray filteredArrayUsingPredicate:predicate];
    return newPersonsArray;
}

- (void)updateTableView {
    self.personsArray = [self deletePersonFromTable];
}

#pragma mark - fetchRequest

- (NSFetchRequest *)getFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"The person"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ OR lastName %@", self.searchBar.text, self.searchBar.text];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    return fetchRequest;
}

#pragma mark - searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Search text %@", self.searchBar.text);
//    [self findEntityInCoreDataWithSearchBar];
}

- (void)findEntityInCoreDataWithSearchBar {
    NSError *error = nil;
    self.personsArray = [self.coreDataContext executeFetchRequest:[self getFetchRequest] error:nil];
    if (!self.personsArray) {
        NSLog(@"Erroe fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

//#pragma mark - fetchResultsController\
//
//- (instancetype)initWithFetchRequest: (NSFetchRequest *) fetchRequest managedObjectContext:(nonnull NSManagedObjectContext *)context sectionNameKeyPath:(nullable NSString *)sectionNameKeyPath cacheName:(nullable NSString *)name {
//    return
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    fetching
    
    [self.personsTableView reloadData];
}

@end







