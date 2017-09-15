
import UIKit
import os.log

class DogTableViewController: UITableViewController {
    
// MARK: Properties
    var Dogs = [RowDog]()
    
//MARK: Actions
    @IBAction func unwindToDogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let dog = sourceViewController.dog {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing dog.
                Dogs[selectedIndexPath.row] = dog
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: Dogs.count, section: 0)
                
                Dogs.append(dog)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
         
            }
            // Save the meals.
            saveDogs()
        }
    }
    
//MARK: Private methods
    private func loadSampleDogs() {
        
        let photo1 = UIImage(named: "dog0")
        let photo2 = UIImage(named: "dog1")
        let photo3 = UIImage(named: "dog2")
        
        guard let dog0 = RowDog(name: "Бобик", photo: photo1) else {
            fatalError("Unable to instantiate dog0")
        }
        
        guard let dog1 = RowDog(name: "Снуп", photo: photo2) else {
            fatalError("Unable to instantiate dog1")
        }
        
        guard let dog2 = RowDog(name: "Шарик", photo: photo3) else {
            fatalError("Unable to instantiate dog2")
        }
        
        Dogs += [dog0, dog1, dog2] //ADD TO ARRAY
    }
    
    private func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Dogs, toFile: RowDog.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Dogs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save dogs...", log: OSLog.default, type: .error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
       
        // Load any saved meals, otherwise load sample data.
        if let savedDogs = loadDogs() {
            Dogs += savedDogs
        }
        else {
            // Load the sample data.
            loadSampleDogs()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // More Sections!!!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Dogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DogTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DogTableViewCell
            else {
            fatalError("The dequeued cell is not an instance of DogTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let dog = Dogs[indexPath.row]
        
        cell.mainTextLabel.text = dog.name
        cell.photoImageView.image = dog.photo
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Dogs.remove(at: indexPath.row)
            saveDogs()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new dog.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let dogDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDogCell = sender as? DogTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDogCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDog = Dogs[indexPath.row]
            dogDetailViewController.dog = selectedDog
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    private func loadDogs() -> [RowDog]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: RowDog.ArchiveURL.path) as? [RowDog]
    }
}
