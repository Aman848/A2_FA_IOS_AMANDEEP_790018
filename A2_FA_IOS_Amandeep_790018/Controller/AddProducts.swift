//
//  ViewController.swift
//  A2_FA_IOS_Amandeep_790018
//
//  Created by user191884 on 2/1/21.
//

import UIKit
import CoreData

class AddProducts: UIViewController {
   
    
    
   // MARK: - CoreData manipulation - appDelegate and the context
    
    // 1 - creating an instance of AppDelage
    /// appDelegaet instance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 2 - create the context
    var managedContext: NSManagedObjectContext!
    
    var products: [Product]?

    
    
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 2 - create the context
        /// the context to use for the coreData
        managedContext = appDelegate.persistentContainer.viewContext
        
       NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        
     // loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        
        loadCoreData()
    }
    
    func getDataFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/data.txt")
        return filePath
    }

    @IBAction func addList(_ sender: UIBarButtonItem) {
    
        _ = Int(textFields[0].text ?? "")
        _ = textFields[1].text ?? ""
        _ = textFields[2].text ?? ""
        _ = Int(textFields[3].text ?? "")
        _ = textFields[4].text ?? ""
        
        let product = Product()
        products?.append(product)
        
        for textField in textFields {
            textField.text = ""
            textField.resignFirstResponder()
        }
     //   let product = Product.self
    //   products?.append(Product(id: id, name: name, describe: describe, price: price, provider: provider))
   //     for textField in textFields {
    //        textField.text = ""
     //       textField.resignFirstResponder()
      //  }
    }
    
    func loadData() {
        products = [Product]()
        
        let filePath = getDataFilePath()
        
        if FileManager.default.fileExists(atPath: filePath) {
            
            do {
                // creating string of the file path
                let fileContent = try String(contentsOfFile: filePath)
                // seperating the products from each other
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    // seperating each product's contents
                    let productContent = content.components(separatedBy: ",")
                    if productContent.count == 5 {
                        let product = Product()
                        products?.append(product)
                    }
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productListTableVC = segue.destination as? ProductTVC {
            productListTableVC.products = self.products!
        }
    }
    
    @objc func saveData() {
        let filePath = getDataFilePath()
        
        var saveString = ""
        for product in products! {
           saveString = "\(saveString)\(product.id),\(String(describing: product.name) ),\(String(describing: product.describe)),\(product.price),\(String(describing: product.provider))\n"
        }
        
        do {
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    //MARK: - CoreData functions
    
    func loadCoreData() {
        products = [Product]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in (results as! [NSManagedObject]) {
                    _ = result.value(forKey: "id") as! Int
                    _ = result.value(forKey: "name") as! String
                    _ = result.value(forKey: "describe") as! String
                    _ = result.value(forKey: "price") as! Int
                    _ = result.value(forKey: "provider") as! String
                    
                    let product = Product()
                    products?.append(product) }
            }
            
        } catch {
            print(error)
        }
    }
    
    @objc func saveCoreData() {
        clearCoreData()
        for product in products! {
            let productEntity = NSEntityDescription.insertNewObject(forEntityName: "Product", into: managedContext)
            productEntity.setValue(product.id, forKey: "id")
            productEntity.setValue(product.name, forKey: "name")
            productEntity.setValue(product.describe, forKey: "describe")
            productEntity.setValue(product.price, forKey: "price")
            productEntity.setValue(product.provider, forKey: "provider")        }
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func clearCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
//        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
        } catch {
            print("Error deleting records \(error)")
        }
        
    }
    
}


