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
        presentHypeAlert(for: nil)
    }
    
    // MARK: _@Class-Methods
	    /**©------------------------------------------------------------------------------©*/
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
    /**©------------------------------------------------------------------------------©*/
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    // MARK: _@Alert Controller
    

    // MARK: - Table view data source
    /**©------------------------------------------------------------------------------©*/
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let hype = HypeModelController.shared.hypeList[indexPath.row]
            guard hype.userRef?.recordID == UserModelController.shared.currentUser?.recordID
            else { return  }
            
            presentHypeAlert(for: hype)
        }

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

        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {

                // Delete the row from the data source
                // Access the hype to delete
                let hypeToDelete = HypeModelController.shared.hypeList[indexPath.row]
                guard let index = HypeModelController.shared.hypeList.firstIndex(of: hypeToDelete) else { return }

                HypeModelController.shared.deleteHype(hypeToDelete) { result in
                    switch result {
                    case .success(let success):
                        if success {
                            HypeModelController.shared.hypeList.remove(at: index)
                            DispatchQueue.main.async {
                                tableView.deleteRows(at: [indexPath], with: .fade)
                            }
                        }
                    case .failure(let error):
                        printf(error.localizedDescription)
                    }
                }
            }
        }
    }// END OF CLASS
    /**©------------------------------------------------------------------------------©*/

// MARK: _@extension HypeListTableViewController
/**©------------------------------------------------------------------------------©*/
extension HypeListTableViewController {
    /*
    // MARK: _@presentHypeAlert
    */
    func presentHypeAlert(for hype: Hype?) {
        // Get an instance of our alert controller
        let alertController = UIAlertController(title: "Get Hype!..", message: "Hyper Active Kid!!!", preferredStyle: .alert)

        // Text field for our alert controller
        alertController.addTextField { (textField) in
            textField.placeholder = "What is hype today?.."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let hype = hype {
                textField.text = hype.body
            }
        }

        // Alert controllers actions
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in

            guard let text = alertController.textFields?.first?.text,
                  !text.isEmpty else {
                return
            }

            if let hype = hype {
                hype.body = text
                HypeModelController.shared.updateHype(hype) { result in
                    switch result {
                    case .success(_):
                        self.updateViews()
                    case .failure(let error):
                        printf(error.localizedDescription)
                    }
                }
            } else {
            HypeModelController.shared.saveHype(with: text) { (result) in
                switch result {
                case .success(let hype):
                    guard let hype = hype else {
                        return
                    }
                    HypeModelController.shared.hypeList.insert(hype, at: 0)
                    self.updateViews()

                case .failure(let error):
                    printf(error.errorDescription)
                }
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
