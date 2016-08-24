//
//  StorageTest.swift
//  Analytics
//
//  Created by Tony Xiao on 8/24/16.
//  Copyright © 2016 Segment. All rights reserved.
//

import Quick
import Nimble

class StorageTest : QuickSpec {
  override func spec() {
    var storage : SEGFileStorage!
    beforeEach {
      let url = SEGFileStorage.applicationSupportDirectoryURL()
      expect(url).toNot(beNil())
      expect(url?.lastPathComponent) == "Application Support"
      storage = SEGFileStorage(folder: url!, crypto: nil)
    }
    
    it("creates folder if none exists") {
      let tempDir = NSURL(fileURLWithPath: NSTemporaryDirectory())
      let url = tempDir.URLByAppendingPathComponent(NSUUID().UUIDString)
      expect(url.checkResourceIsReachableAndReturnError(nil)) == false
      _ = SEGFileStorage(folder: url, crypto: nil)
      
      var isDir: ObjCBool = false
      let exists = NSFileManager.defaultManager().fileExistsAtPath(url.path!, isDirectory: &isDir)
      
      expect(exists) == true
      expect(Bool(isDir)) == true
    }
    
    it("persists and loads data") {
      let dataIn = "segment".dataUsingEncoding(NSUTF8StringEncoding)!
      storage.setData(dataIn, forKey: "mydata")
      
      let dataOut = storage.dataForKey("mydata")
      expect(dataOut) == dataIn
      
      let strOut = String(data: dataOut!, encoding: NSUTF8StringEncoding)
      expect(strOut) == "segment"
    }
    
    it("persists and loads string") {
      let str = "san francisco"
      storage.setString(str, forKey: "city")
      expect(storage.stringForKey("city")) == str
    }
    
    it("persists and loads array") {
      let array = [
        "san francisco",
        "new york",
        "tallinn",
      ]
      storage.setArray(array, forKey: "cities")
      expect(storage.arrayForKey("cities") as? Array<String>) == array
    }
    
    it("persists and loads dictionary") {
      let dict = [
        "san francisco": "tech",
        "new york": "finance",
        "paris": "fashion",
      ]
      storage.setDictionary(dict, forKey: "cityMap")
      expect(storage.dictionaryForKey("cityMap") as? Dictionary<String, String>) == dict
    }
    
    it("saves file to disk") {
      let key = "input.txt"
      let url = storage.urlForKey(key)
      expect(url.checkResourceIsReachableAndReturnError(nil)) == false
      storage.setString("sloth", forKey: key)
      expect(url.checkResourceIsReachableAndReturnError(nil)) == true
    }
    
    afterEach {
      storage.removeKey("input.txt")
    }
  }
}
