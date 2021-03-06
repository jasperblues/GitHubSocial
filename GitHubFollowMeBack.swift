#!/usr/bin/swift

import Foundation

import Foundation

open class GitHubSocialChecker : NSObject {
    
    fileprivate var userName : String!
    
    public init(userName : String!) {
        self.userName = userName
        super.init()
    }
    
    
    open func check() {
        let followers = self.collectFromEndpoint("followers")
        let following = self.collectFromEndpoint("following")
        
        print("<========================================================")
        print(NSString(format: "Follower stats for: %@", self.userName))
        print("<========================================================")
        print("Following, but not followed by:");
        self.withCollection(following, reportMissingFrom: followers)
        print("<end of report>")
        
        print("");
        print("Followed by, but not following:");
        print("<========================================================")
        self.withCollection(followers, reportMissingFrom: following)
        print("<end of report>")
        
    }
    
    
    fileprivate func collectFromEndpoint(_ endpoint : String) -> Array<String> {
        
        var collection : Array<String> = []
        
        print(NSString(format: "Loading %@ . . . ", endpoint))
        var page = 1
        while (true) {
            let urlString : String! = NSString(format: "https://api.github.com/users/%@/%@?per_page=100&page=%i",
                self.userName, endpoint, page) as String
            let url = URL(string: urlString)!
            
            let data = try! Data(contentsOf: url)
            
            
            
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Dictionary<String, AnyObject>>
                
                if (results.count == 0) {
                    break;
                }
                for dictionary : Dictionary in results {
                    let login = dictionary["login"] as! String
                    collection.append(login)
                    
                }
                page += 1
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
                exit(1)
                
            }
            
        }
        print(NSString(format: "Counted %lu %@", collection.count, endpoint))
        return collection
        
    }
    
    fileprivate func withCollection(_ collection : Array<String>, reportMissingFrom other : Array<String>) -> Void {
        
        for userName in collection {
            if other.filter({$0 == userName}).count == 0 {
                print(userName)
            }
        }
    }
    
}

let arguments : Array<String> = CommandLine.arguments;
if (arguments.count != 2) {
    print("Usage: ./GitHubFollowMeBack.swift <userName>")
}

var checker = GitHubSocialChecker(userName: arguments[1])
checker.check()

