import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
    
    init()
    {
        
        //adding 5 random items to all items array. This needs to be removed in the future
        for _ in 0..<5{
            createItem()
        }
    }
    
    
    
    //@discardableResult annotation means that the caller of this function is free to ignore the result of calling this function
    @discardableResult  func createItem() -> Item
    {
        //creating random item using the initialiser declared in item class.
        //In future this func will recieve details such as item name, value in dollars(optional)
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
        
    }
}
