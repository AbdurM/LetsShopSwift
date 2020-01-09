import UIKit
import CoreData

class ItemStore {
    
    //MARK: -Properties
    var allItems = [Item]()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Letsshop")
        
        container.loadPersistentStores{
            (description, error) in
            
            if let error = error {
                print("Error setting up core data: \(error)")
            }
        }
        
        return container
    }()
    
    
    
    //MARK: - Archiving and unarchiving
    
    //url of the archive file where all the instances of item are/can be saved
       var itemArchiveURL: URL = {
          
           let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           
           let documentDirectory = documentDirectories.first!
           
           return documentDirectory.appendingPathComponent("items.archive")
           
       }()
    
    init()
       {
        // get the archived item array
           let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item]
           
           if let itemArray = archivedItems{
               allItems = itemArray
           }
           
       }
    //archiving
    func saveChanges() -> Bool{
        do{
            //note: NSKeyedArchiver is the concrete implementation of NSCoder which is used to encode the item objects
            
            //encoding into data representation
            let data = try NSKeyedArchiver.archivedData(withRootObject: allItems, requiringSecureCoding: false)
            
            try data.write(to: itemArchiveURL)
            
            return true
        }
        catch{
            print("Archiving items failed due to \(error)")
            return false
        }
    }
    
    //MARK: - Item creation, deletion and move
    
    //@discardableResult annotation means that the caller of this function is free to ignore the result of calling this function
    @discardableResult  func createItem() -> Item
    {
        //creating random item using the initialiser declared in item class.
        //In future this func will recieve details such as item name, value in dollars(optional)
        let newItem = createItem(into: persistentContainer.viewContext)
        
        allItems.append(newItem)
        
        return newItem
        
    }
    
    
    func removeItem(_ item: Item)
    {
        if let index = allItems.firstIndex(of: item)
        {
            allItems.remove(at: index)
        }
    }
    
    
    func moveItem(from fromIndex: Int,to toIndex: Int )
    {
        if fromIndex == toIndex
        {
            return
        }
        
        let movedItem = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        
        allItems.insert(movedItem, at: toIndex)
    }
    
    func createItem(into context: NSManagedObjectContext) -> Item
       {
       //right now creates random items without any help from the user.
           let adjectives = ["Fresh", "Nice", "New"]
           
           let nouns = ["Milk","Bread", "Juice"]
           
           var idx = arc4random_uniform(UInt32(adjectives.count))
           
           let randomAdjective = adjectives[Int(idx)]
           
           idx = arc4random_uniform(UInt32(nouns.count))
           
           let randomNoun = nouns[Int(idx)]
           
           let randomName = "\(randomAdjective) \(randomNoun)"
           
           let randomValue = Double(arc4random_uniform(100))
           
           let dateCreated = Date()

           var item: Item!
           
           context.performAndWait {
               
               item = Item(context: context)
               item.name = randomName
               item.valueInDollars = randomValue
               item.dateCreated = dateCreated
               item.itemKey = UUID().uuidString
               item.bought = false
           }
           
           return item
       }
    
    
   
}
