//
//  MainVC
//  DreamLister
//
//  Created by Ryan Kim on 6/13/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemSegment: UISegmentedControl!

    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        hasLaunchedYet()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func attemptFetch() -> [Item]? {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "createdAt", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)

        switch itemSegment.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
            break
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
            break
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
            break
        case 3:
            fetchRequest.sortDescriptors = [typeSort]
            break
        default:
            break
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        let fetchedItems = controller.fetchedObjects
        return fetchedItems
 
    }
    
    func hasLaunchedYet() {
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched {
            generateTestData()
            defaults.set(true, forKey: hasLaunchedKey)
        }
    }
    
    func configrueCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func generateTestData() {
        let itemType = ItemType(context: context)
        itemType.type = "Electronics"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Toy"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Car"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Tool"
        
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 1800
        item.details = "New Macbook Proc coming soon in 2 months! Hope to buy it soon."
        item.toItemType = itemType
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphone"
        item2.price = 300
        item2.details = "The best headphone ever"
        item2.toItemType = itemType

        let item3 = Item(context: context)
        item3.title = "Ferarri"
        item3.price = 200000
        item3.details = "Vrum vrum!"
        item3.toItemType = itemType3
        
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Frys Electronics"
        let store4 = Store(context: context)
        store4.name = "Target"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "H K Mart"
        
        ad.saveContext()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        itemTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell
        self.configrueCell(cell: cell!, indexPath: indexPath as NSIndexPath)
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    //2 protocols added to enable swipable action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let fectchedItems = self.attemptFetch()
            if let fectchedItems = fectchedItems {
                context.delete((fectchedItems[indexPath.row]))
                ad.saveContext()
                print("Successfully deleted an item")
            } else {
                 print("No fetched data")
            }
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                itemTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                itemTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = itemTableView.cellForRow(at: indexPath) as! ItemCell
                self.configrueCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                itemTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                itemTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}






















