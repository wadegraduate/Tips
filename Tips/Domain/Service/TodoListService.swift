//
//  TodoListUseCase.swift
//  TipGenius
//
//  Created by Wadealanchan on 15/4/2024.
//

import Foundation
import RealmSwift

protocol TodoListService {
    var tasksStream: AsyncStream<[TaskItem]> { get }
    func addTask(task: TaskItem)
    func editTask(task: TaskItem)
    func deleteTask(task: TaskItem)
}


final class DefaultTodoListService: TodoListService {
    
    private var continuation: AsyncStream<[TaskItem]>.Continuation
    let tasksStream: AsyncStream<[TaskItem]>
    
    @ObservedResults(TaskItemObject.self) private var storedTaskItems
    
    private var token: NotificationToken?
    
    init() {
        var continuation: AsyncStream<[TaskItem]>.Continuation!
        tasksStream = AsyncStream { c in
            continuation = c
        }
        self.continuation = continuation
        setupObserver()
    }
    
    private func setupObserver() {
        do {
            let realm = try Realm()
            let results = realm.objects(TaskItemObject.self)
            
            token = results.observe({ [weak self] changes in
                let tasks = Array(results.map(TaskItem.init))
                self?.continuation.yield(tasks)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addTask(task: TaskItem) {
        let task = TaskItemObject(taskItem: task)
        $storedTaskItems.append(task)
    }
    
    func editTask(task: TaskItem) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: task.id)
            if let object = realm.object(ofType: TaskItemObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    object.title = task.title
                    object.isCompleted = task.isCompleted
                    object.isStarred = task.isStarred
                    object.dueDate = task.dueDate
                    object.note = task.note
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteTask(task: TaskItem) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: task.id)
            if let object = realm.object(ofType: TaskItemObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(object)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
}
