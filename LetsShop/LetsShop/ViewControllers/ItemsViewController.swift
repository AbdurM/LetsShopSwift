import UIKit

class ItemsViewController: UITableViewController
{
    //MARK: - Properties
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    
    //MARK: - Formatters
    //Note to self: We have a duplicate date formatter  in detail view controller. Probably you can write a util class that will enable both of these to share the dateFormatter. Do it after you've implemented the service locator pattern.
    let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .none
         return formatter
     }()
    
    //MARK: - Actions
    @IBAction func addNewItem(_ sender: UIBarButtonItem)
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
   
    //MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    //MARK: - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row{
                
                let item = itemStore.allItems[row]
                
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
                
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    //MARK: - UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemStore.allItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemStore.allItems[indexPath.row]
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let itemName = item.name
        
        let dateCreatedString = dateFormatter.string(from: item.dateCreated)
        
        let valueInDollarsString = {
          
            () -> String? in
            
            guard let valueInDollars = item.valueInDollars else
            {
                return ""
            }
            return "$\(valueInDollars)"
        }()
        
        let itemBought = item.bought
            
        itemCell.setup(name: itemName, valueInDollars: valueInDollarsString!, dateCreated: dateCreatedString, itemBought: itemBought)
        
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
                //remove the item's image from imageStore
                self.imageStore.deleteImage(forKey: item.itemKey)
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
    
   
    
}
