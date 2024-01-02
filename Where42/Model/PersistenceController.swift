////
////  PersistenceController.swift
////  Where42
////
////  Created by 현동호 on 11/21/23.
////
//
// import CoreData
// import Foundation
//
// struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "Model")
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Undresolved error \(error). \(error.userInfo)")
//            }
//        }
//    }
//
//    func saveContext() {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Undresolved error \(nserror). \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func save(context: NSManagedObjectContext) {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Undresolved error \(nserror). \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func CreateUserInfo(context: NSManagedObjectContext) {
////        let userInfo = UserInfomation(context: context)
//        // userInfo.name = dhyun
//
//        save(context: context)
//    }
//
//    func DeleteUserInfo(userInfo: UserInfomation, context: NSManagedObjectContext) {
//        context.delete(userInfo)
//
//        do {
//            try context.save()
//        } catch {
//            let nserror = error as NSError
//            fatalError("Undresolved error \(nserror). \(nserror.userInfo)")
//        }
//    }
// }
