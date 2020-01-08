
//Note: Because the images tend to get very large, it is a good idea to keep them sepearate from other data. Images will be stored in an instance of this class. It will fetch and cache the images as required. It will also be able to flush the cache if the device runs low on memory.

import UIKit

class ImageStore{
    
    let cache = NSCache<NSString, UIImage>()
    
    //MARK: - For saving, fetching and deletion of images in CACHE
    
    func setImage(_ image: UIImage, forKey key: String)
    {
        //this stores the image in cache
        cache.setObject(image, forKey: key as NSString)
        
        //the following code stores the image in file system
        
        let url = imageURL(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 0.5)//this is where we are converting it into data
        {
            try? data.write(to: url, options: [.atomic])// this is where we write it to the url. Atomic      prevents data corruption
        }
        
    }
    
    func image(forKey key: String) -> UIImage?
    {
        //check the cache first for the image
        if let existingImage = cache.object(forKey: key as NSString)
        {
            return existingImage
        }
        // If not, look into the file system
        let url = imageURL(forKey: key)
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        //finally, if file is  saving the image found in the file system into cache
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        
        return imageFromDisk
        
    }
    
    func deleteImage(forKey key: String)
    {
        //deleting from the cache
        cache.removeObject(forKey: key as NSString)
        
        //deleting from the file system
        let url = imageURL(forKey: key)
        
        do
        {
          try FileManager.default.removeItem(at: url)
        }
        catch
        {
            print("The image could'nt be deleted from the file system due to :\(error)")
        }
        
    }
    
    //For saving in the file system
    func imageURL(forKey key: String) -> URL
    {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
        
    }
    
     
}
