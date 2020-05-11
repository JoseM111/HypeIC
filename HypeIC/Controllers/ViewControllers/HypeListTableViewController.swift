import UIKit

class HypeListTableViewController: UITableViewController {
        
    // MARK: @Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    
    // MARK: _@Live cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        loadData()
    }
    
    // MARK: _@IBAction
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        presentAddHypeAlert()
    }
    
    // MARK: _@Class-Methods
    func setUpViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new hypes...")
        // Add a target
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // Adding a subview
        tableView.addSubview(refresh)
    }
    
    @objc func loadData() {
        HypeModelController.shared.fetchAllHypes { (result) in
            switch result {
                case .success(let hypes):
                    guard let hypes = hypes else { return }
                    HypeModelController.shared.hypeList = hypes
                    self.updateViews()
                
                case .failure(let error):
                    printf(error.localizedDescription)
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    // MARK: _@Alert Controller
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        HypeModelController.shared.hypeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        // Access our `Hype` object
        let hype = HypeModelController.shared.hypeList[indexPath.row]
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timeStamp.dateRightNow()

        return cell
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

}/// END OF CLASS

extension HypeListTableViewController {
    func presentAddHypeAlert() {
        // Get an instance of our alert controller
        let alertController = UIAlertController(title: "Get Hype!..", message: "Hyper Active Kid!!!", preferredStyle: .alert)
        
        // Text field for our alert controller
        alertController.addTextField { (textField) in
            textField.placeholder = "What is hype today?.."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        // Alert controllers actions
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            
            guard let text = alertController.textFields?.first?.text,
                !text.isEmpty else { return }
            
            HypeModelController.shared.saveHype(with: text) { (result) in
                switch result {
                    case .success(let hype):
                        guard let hype = hype else { return }
                        HypeModelController.shared.hypeList.insert(hype, at: 0)
                        self.updateViews()
                    
                    case .failure(let error):
                        printf(error.errorDescription)
                }
            }
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}
