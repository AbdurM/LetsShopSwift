import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
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
