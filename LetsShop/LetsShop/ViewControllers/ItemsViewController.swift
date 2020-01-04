import UIKit

class ItemsViewController: UITableViewController
{
    var itemStore: ItemStore!
    
    //region @IBAction
    @IBAction func addNewItem(_ sender: UIButton)
    {
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.firstIndex(of: newItem)
        {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton)
    {
        if isEditing{
            
            sender.setTitle("Edit", for: .normal)
            
            setEditing(false, animated: false)
        }
        else{
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    //End region @IBAction
    
    //region UIViewController lifecycle callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //End region UIViewController lifecycle callbacks
    
    //region overriding UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemStore.allItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        if let valueInDollars = item.valueInDollars
        {
            cell.detailTextLabel?.text = "$\(valueInDollars)"
        }
        
        return cell
    }
    
    //to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            let item = itemStore.allItems[indexPath.row]
            
            itemStore.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //to move items
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //End region overriding UITableViewDataSource methods
}
