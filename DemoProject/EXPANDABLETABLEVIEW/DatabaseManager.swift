//
//  DatabaseManager.swift
//  FirebaseDemo
//
//  Created by Ajeet Singh on 21/12/17.
//  Copyright © 2017 Lanetteam. All rights reserved.
//

import UIKit
import FMDB
class DatabaseManager: NSObject {
    static let shared: DatabaseManager = DatabaseManager()
    let databaseFileName = "FirebaseChatApp.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    var AppObj = (UIApplication.shared.delegate as? AppDelegate)
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    var message_Id: String = ""
    var senderName: String = ""
    var senderId: String = ""
    var message_text: String = ""
    var date: String = ""
    
    func createDatabase() -> Bool {
        var created = false
        print("DATABSE PATH:: \(pathToDatabase)")
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                // Open the database.
                if database.open() {
                    let createChatTableQuery = "create table tbl_Chat (id integer primary key AUTOINCREMENT,message_Id text,channel_Id text, message_text text, senderId text,senderName text,date text)"
                    do {
                        try database.executeUpdate(createChatTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }else{
            database = FMDatabase(path: pathToDatabase!)
            
        }
        
        return created
    }
    
        func addChatData(messageInfo: MessageObj) -> Bool
        {
            database = FMDatabase(path: pathToDatabase!)
            database.open()
            
            let isInserted = database!.executeUpdate("INSERT or replace INTO  tbl_Chat (message_Id ,channel_Id, message_text,senderId,senderName,date) VALUES (?,?,?,?,?,?)", withArgumentsIn: [messageInfo.message_Id,messageInfo.channel_Id,messageInfo.message_text,messageInfo.senderId,messageInfo.senderName,messageInfo.date])
            database.close()
            return isInserted
        }
    
    func getAllChatData(strChannelId: String) -> [MessageObj] {
        database = FMDatabase(path: pathToDatabase!)
        database.open()
        
        //        let resultSet: FMResultSet! = database.executeQuery("select * from tbl_Chat where groupId = '\(SHARED_MGR.groupID)' ORDER BY message_CreatedAt DESC", withArgumentsIn: [""])
        
        
        var  arrChatInfo : [MessageObj] = [MessageObj]()
        FMDatabaseQueue.self().inDatabase({(_ db: FMDatabase) -> Void in
            let resultSet: FMResultSet! = database.executeQuery("select * from tbl_Chat where channel_Id = '\(strChannelId)'", withArgumentsIn: [""])
            if (resultSet != nil) {
                while resultSet.next() {
                    let chatInfo : MessageObj = MessageObj()
                    chatInfo.message_Id  = resultSet.string(forColumn: "message_Id")!
                    chatInfo.message_text = resultSet.string(forColumn: "message_text")!
                    chatInfo.senderName = resultSet.string(forColumn: "senderName")!
                    chatInfo.senderId = resultSet.string(forColumn: "senderId")!
                    chatInfo.date = resultSet.string(forColumn: "date")!
                    chatInfo.channel_Id = resultSet.string(forColumn: "channel_Id")!
                    arrChatInfo.append(chatInfo)
                }
            }
        })
        database.close()
        
        return arrChatInfo
    }



}
