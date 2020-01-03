import UIKit

class Item: NSObject{
    var name: String
    var valueInDollars: Int?
    let dateCreated: Date
    
    
    init(name: String, valueInDollars: Int?)
    {
        self.name = name
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        
        super.init()
    }
    
    convenience init(name: String)
    {
        self.init(name: name, valueInDollars: nil)
    }
    
    
    //for testing purposes
    // to be removed once the app is ready
    convenience init(random: Bool = false)
    {
        if random {
            let adjectives = ["Fresh", "Nice", "New"]
            
            let nouns = ["Milk","Bread", "Juice"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            
            let randomValue = Int(arc4random_uniform(100))
            
            self.init(name: randomName, valueInDollars: randomValue)
        }
        else
        {
            self.init(name: "", valueInDollars: nil)
        }
    }
}
