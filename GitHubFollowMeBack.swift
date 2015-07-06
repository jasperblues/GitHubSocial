#!/usr/bin/swift

import Foundation

public class GitHubSocialChecker : NSObject {

    private var userName : String!
    
    public init(userName : String!) {
        self.userName = userName
        super.init()
    }


    public func check() {
        let followers = self.collectFromEndpoint("followers")
        let following = self.collectFromEndpoint("following")
        
        println("<========================================================")
        println(NSString(format: "Follower stats for: %@", self.userName))
        println("<========================================================")
        println("Following, but not followed by:");
        self.withCollection(following, reportMissingFrom: followers)
        println("<end of report>")

        println("");
        println("Followed by, but not following:");
        println("<========================================================")
        self.withCollection(followers, reportMissingFrom: following)
        println("<end of report>")
    
    }
    
    
    private func collectFromEndpoint(endpoint : String) -> Array<String> {
    
        var collection : Array<String> = []
    
        print(NSString(format: "Loading %@ . . . ", endpoint))
        var page = 1
        while (true) {
            let urlString : String! = NSString(format: "https://api.github.com/users/%@/%@?per_page=100&page=%i",
                self.userName, endpoint, page) as! String
            let url = NSURL(string: urlString)!
            
            let data = NSData(contentsOfURL: url)!
            
            let jsonError: NSError?
            let results = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! Array<Dictionary<String, AnyObject>>
            
            if (results.count == 0) {
                break;
            }
            for dictionary : Dictionary in results {
                let login = dictionary["login"] as! String
                collection.append(login)
                
            }
            page++
        }
        println(NSString(format: "Counted %lu %@", collection.count, endpoint))
        return collection
        
    }
    
    private func withCollection(collection : Array<String>, reportMissingFrom other : Array<String>) -> Void {
        
        for userName in collection {
            if other.filter({$0 == userName}).count == 0 {
                println(userName)
            }
        }
    }

}

let arguments : Array<String> = Process.arguments;
if (arguments.count != 2) {
    println("Usage: ./GitHubFollowMeBack.swift <userName>")
}

var checker = GitHubSocialChecker(userName: arguments[1])
checker.check()




