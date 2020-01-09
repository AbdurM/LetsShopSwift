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
    
    
    init()
       {
        
        //fetch previosly saved items from NSManagedObjectContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //sort description to fetch items according to dateCreated in ascending order
        let sortByDateCreated = NSSortDescriptor(key: #keyPath(Item.dateCreated), ascending: true)
        
        fetchRequest.sortDescriptors = [sortByDateCreated]
        
        let viewContext = persistentContainer.viewContext
        
        viewContext.performAndWait {
            do
            {
                let prevStoredItems = try viewContext.fetch(fetchRequest)
                self.allItems = prevStoredItems
            }
            catch
            {
                print("Loading old items failed due to error: \(error)")
            }
            
        }
           
       }
   
    //MARK: - Item creation, deletion and move
    
    //@discardableResult annotation means that the caller of this function is free to ignore the result of calling this function
    @discardableResult  func createItem() -> Item
    {
        //creating random item using the initialiser declared in item class.
        //In future this func will recieve details such as item name, value in dollars(optional)
        let newItem = createItem(into: persistentContainer.viewContext)

        saveChangesToViewContext()
        
        allItems.append(newItem)
        
        return newItem
        
    }
    
    
    func removeItem(_ item: Item)
    {
        if let index = allItems.firstIndex(of: item)
        {
            persistentContainer.viewContext.delete(item)
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
    
    func saveChangesToViewContext()
    {
          do
          {
              try persistentContainer.viewContext.save()
          }
          catch
          {
              print("Saving to context failed due to error: \(error)")
          }
     }
   
}
