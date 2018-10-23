//
//  ViewController.swift
//  CoreDataTest
//
//  Created by YOUNGSIC KIM on 2018-10-21.
//  Copyright © 2018 YOUNGSIC KIM. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            title = "The List"
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    var context: NSManagedObjectContext! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var names:[String] = []
    var people: [NSManagedObject] = []
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
//            self.names.append(nameToSave)
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try context.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(name:String) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        let person = NSManagedObject(entity: entity, insertInto: context)
        person.setValue(name, forKey: "name")
        do {
            try context.save()
            people.append(person)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String//names[indexPath.row]
        return cell
    }
}
