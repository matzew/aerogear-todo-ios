/*
 * JBoss, Home of Professional Open Source
 * Copyright 2012, Red Hat, Inc., and individual contributors
 * by the @authors tag. See the copyright.txt in the distribution for a
 * full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "AGTasksViewController.h"

#import "AeroGear.h"

@implementation AGTasksViewController {
    NSArray *_tasks;
}

-(void)dealloc {
    DLog(@"AGTasksViewController dealloc");    
}

- (void)viewDidUnload {
    DLog(@"AGTasksViewController viewDidUnLoad");
    
    _tasks = nil;
    
    [super viewDidUnload];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    DLog(@"AGTasksViewController viewDidLoad");
    
    self.title = @"Tasks";
	
    // set up toolbar items
    UIBarButtonItem *editButton = self.editButtonItem; 
    [editButton setTarget:self];
    [editButton setAction:@selector(toggleEdit)];
    self.navigationItem.leftBarButtonItem = editButton;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self 
                                                                               action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addButton;    
    
    // used to fill up space left and right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refresh)];
    UIBarButtonItem *filterProjectsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"projects.png"] 
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(filterByProject)];
    UIBarButtonItem *filterTagsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tags.png"] 
                                                                         style:UIBarButtonItemStylePlain
                                                                         target:self 
                                                                        action:@selector(filterByTag)];
    
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:info.currentImage style:UIBarButtonItemStylePlain target:self action:@selector(displayInfo)];
    
    self.toolbarItems = [NSArray arrayWithObjects:refreshButton, flexibleSpace, filterProjectsButton, filterTagsButton, flexibleSpace, infoButton, nil];
    
    [self refresh];

  	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableCellIdentifier";
    
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSDictionary *task = [_tasks objectAtIndex:row];
    
    cell.textLabel.text = [task valueForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;    
    
    return cell;
}

#pragma mark - Action Methods
- (IBAction)refresh {
    // some SIMPLE loadings.....
    NSURL* projectsURL = [NSURL URLWithString:@"http://todo-aerogear.rhcloud.com/todo-server/"];
    AGPipeline* todo = [AGPipeline  pipelineWithPipe:@"tasks" baseURL:projectsURL type:@"REST"];
    
    id<AGPipe> projects = [todo get:@"tasks"];
    
    [projects read:^(id responseObject) {
        _tasks = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"READ: An error occured! \n%@", error);
    }];
}

- (IBAction)addTask {
    // TODO
}

- (IBAction)filterByProject {
    // TODO
}

- (IBAction)filterByTag {
    // TODO
}

- (IBAction)displayInfo {
    // TODO
}

- (void)toggleEdit {
    BOOL editing = !self.tableView.editing;
    self.navigationItem.rightBarButtonItem.enabled = !editing;
    self.navigationItem.leftBarButtonItem.title = (editing) ? @"Done" :  @"Edit";
    [self.tableView setEditing:editing animated:YES];
}

@end
