import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
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
            
            
            print("Saving to \(itemArchiveURL.path)")//for debugging
            
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
        let newItem = Item(random: true)
        
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
    
    
    
    
   
}
