//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ryan Kim on 6/16/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!

    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        picker.delegate = self
        picker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        hideKeyboard()

        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            stores = try context.fetch(fetchRequest)
            if stores.count == 0 {
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
            picker.reloadAllComponents()
        } catch {
            //error handling
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            itemTypes = try context.fetch(fetchRequest)
            if itemTypes.count == 0 {
                let itemType = ItemType(context: context)
                itemType.type = "Electronics"
                let itemType2 = ItemType(context: context)
                itemType2.type = "Toy"
                let itemType3 = ItemType(context: context)
                itemType3.type = "Car"
                let itemType4 = ItemType(context: context)
                itemType4.type = "Tool"
                
                ad.saveContext()
            }
            picker.reloadAllComponents()
        } catch {
        
        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        picker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            if let itemType = item.toItemType {
                var index = 0
                repeat {
                    let t = itemTypes[index]
                    if t.type == itemType.type {
                        picker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                } while (index < itemTypes.count)
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item: Item!
        let picture = Image(context: context)
        let itemType = ItemType(context: context)
        
        itemType.type = itemTypes[picker.selectedRow(inComponent: 1)].type
        picture.image = thumbImage.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toItemType = itemType
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        item.createdAt = NSDate()

        item.toStore = stores[picker.selectedRow(inComponent: 0)]
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        showAlertController()
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete the item?", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let DestructiveAction = UIAlertAction(title: "Yes", style: .destructive) {
            (result : UIAlertAction) -> Void in
            print("Deleting the item")
            if self.itemToEdit != nil {
                context.delete(self.itemToEdit!)
                ad.saveContext()
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "No", style: .default) {
            (result : UIAlertAction) -> Void in
            print("Not deleting the item")
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
 }

extension ItemDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        } else if component == 1 {
            let itemType = itemTypes[row]
            return itemType.type
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        } else if component == 1 {
            return itemTypes.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //updated when selected
    }
    
}

extension ItemDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            thumbImage.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}




