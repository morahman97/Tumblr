//
//  PhotosViewController.swift
//  Tumbr Lab
//
//  Created by Mo on 1/31/18.
//  Copyright © 2018 Mo. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableViewOutlet: UITableView!
    var posts: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.rowHeight = 300
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableViewOutlet.insertSubview(refreshControl, at: 0)
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]

                
                // Reload the table view
                self.tableViewOutlet.reloadData()
            }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    /*
     * Return the count of posts from getting the post data from tumblr API
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    /*
     * Defined and return the photoCell
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        let post = posts[indexPath.row]

        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // 1.
            let photo = photos[0]
            // 2.
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.
            let urlString = originalSize["url"] as! String
            // 4.
            let url = URL(string: urlString)
            cell.curl=url
            cell.imageViewOutlet.af_setImage(withURL: url!)
            

        }
        
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableViewOutlet.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! PhotoDetailsViewController
        
        let cell = sender as! PhotoCell
        let indexPath = tableViewOutlet.indexPath(for: cell)
    
        destinationViewController.url=(tableViewOutlet.cellForRow(at: indexPath!)as!PhotoCell).curl
    }
    
    // Get rid of the gray selection effect by deselecting the cell with animation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
