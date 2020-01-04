import UIKit

class ItemsViewController: UITableViewController
{
    //region Injections
    var itemStore: ItemStore!
    
    //region Actions
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
   
    
    //region view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 65
        
    }
    
    //region UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemStore.allItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = itemStore.allItems[indexPath.row]
        
        itemCell.nameLabel.text = item.name
        
        itemCell.dateCreatedLabel.text = dateToString(item.dateCreated)
        
        if let valueInDollars = item.valueInDollars
        {
            itemCell.valueInDollarsLabel.text = "$\(valueInDollars)"
        }
        
        return itemCell
    }
    
    //to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            let item = itemStore.allItems[indexPath.row]
            
            //show an alert to confirm deletion
            
            let title = "Delete \(item.name)"
            
            let message = "Are you sure you want to delete this item?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title:"Cancel", style: .cancel)
            
            let deleteAction = UIAlertAction(title:"Delete", style: .destructive){
                //remove item only after recieving the confirmation from the user
                (action) -> Void in
                self.itemStore.removeItem(item)
                           
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            //add actions
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            //present the alertController
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //to move items
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //End region overriding UITableViewDataSource methods
    
    
    func dateToString(_ date:Date) -> String
       {
           let formatter = DateFormatter()

           formatter.dateFormat = "dd-MM-yyyy"
           
           return formatter.string(from: date)
       }
}
