//
//  RealmTest.swift
//  CurrentConverterApp
//
//  Created by Georgy on 2024-09-29.
//

import UIKit
import SnapKit
import RealmSwift

class RealmTestScreen: UIViewController {
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm.beginWrite()
        //realm.delete(realm.objects(Person.self))
        try! realm.commitWrite()
        
        save()
        printSaved()
    }
    
    func printSaved() {
        let people = realm.objects(Person.self)
        for person in people {
            let firstName = person.firstName
            let lastName = person.lastName
            let fullName = "\(firstName) \(lastName)"
            print("\(fullName)")
        }
    }
    
    func save() {
        let ivan = Person()
        ivan.firstName = "Semen"
        ivan.lastName = "Budkov"
        
        realm.beginWrite()
        realm.add(ivan)
        try! realm.commitWrite()
    }
}

class Person: Object {
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
}
