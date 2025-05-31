//
//  TaskListInteractorTest.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 31.05.2025.
//
import XCTest
import CoreData
@testable import ToDoList
final class TaskListInteractorTests: XCTestCase {

    var interactor: TaskListInteractor!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
        interactor = TaskListInteractor(persistenceController: controller)
    }

    override func tearDownWithError() throws {
        interactor = nil
        context = nil
    }

    func testAddTask() throws {
        let expectation = self.expectation(description: "Task added")

        interactor.addTask(title: "Test Title", taskDescription: "Test Description") {
            self.interactor.fetchCoreDataTasks { tasks in
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Test Title")
                XCTAssertEqual(tasks.first?.description, "Test Description")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2)
    }

    func testUpdateTask() throws {
        let expectation = self.expectation(description: "Task updated")

        // Add first
        interactor.addTask(title: "Initial", taskDescription: "Initial") {
            self.interactor.fetchCoreDataTasks { tasks in
                guard let task = tasks.first else {
                    XCTFail("No task found")
                    return
                }

                self.interactor.updateTask(
                    id: task.id,
                    newTitle: "Updated Title",
                    newDescription: "Updated Desc",
                    newIsCompleted: true
                ) {
                    self.interactor.fetchCoreDataTasks { updatedTasks in
                        guard let updatedTask = updatedTasks.first else {
                            XCTFail("No task found after update")
                            return
                        }
                        XCTAssertEqual(updatedTask.title, "Updated Title")
                        XCTAssertEqual(updatedTask.description, "Updated Desc")
                        XCTAssertTrue(updatedTask.isCompleted)
                        expectation.fulfill()
                    }
                }
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testDeleteTask() throws {
        let expectation = self.expectation(description: "Task deleted")

        interactor.addTask(title: "To Be Deleted", taskDescription: "Desc") {
            self.interactor.fetchCoreDataTasks { tasks in
                guard let task = tasks.first else {
                    XCTFail("No task to delete")
                    return
                }

                self.interactor.deleteTask(id: task.id) {
                    self.interactor.fetchCoreDataTasks { tasksAfterDelete in
                        XCTAssertTrue(tasksAfterDelete.isEmpty)
                        expectation.fulfill()
                    }
                }
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testSaveTasksToCoreData() throws {
        let expectation = self.expectation(description: "Tasks saved")

        let dummyTasks = [
            TaskEntity(id: 1, title: "Task 1", description: "Desc 1", creationDate: Date(), isCompleted: false, isLocal: false),
            TaskEntity(id: 2, title: "Task 2", description: "Desc 2", creationDate: Date(), isCompleted: true, isLocal: false)
        ]

        interactor.saveTasksToCoreData(tasks: dummyTasks) {
            self.interactor.fetchCoreDataTasks { fetched in
                XCTAssertEqual(fetched.count, 2)
                XCTAssertEqual(fetched[0].title, "Task 1")
                XCTAssertEqual(fetched[1].title, "Task 2")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2)
    }
}
