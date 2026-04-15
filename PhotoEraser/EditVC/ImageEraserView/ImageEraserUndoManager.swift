//
//  ImageEraserUndoManager.swift
//  ImageEraser
//
//  Created by Rashed Nizam on 26/9/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageEraserUndoManagerDelegate {
    func imageEraserUndoManager_ReachedToStart(isReached: Bool)
    func imageEraserUndoManager_ReachedToEnd(isReached: Bool)
    
    func imageEraserUndoManager_UndoneWithPaths(dics: [NSDictionary])
    func imageEraserUndoManager_RedoneWithPaths(dics: [NSDictionary])
}

class ImageEraserUndoManager: NSObject {

    var delegate: ImageEraserUndoManagerDelegate!
    
//    var undoArray = [UIBezierPath]()
//    var undoBackupArray = [UIBezierPath]()
    
    var undoArray = [NSDictionary]()
    var undoBackupArray = [NSDictionary]()
    
    func reset() {
        undoArray.removeAll()
        undoBackupArray.removeAll()
        if (delegate != nil) {
            delegate.imageEraserUndoManager_ReachedToStart(isReached: true)
            delegate.imageEraserUndoManager_ReachedToEnd(isReached: true)
        }
    }
    
    
    func addObject(object: NSDictionary) {
        while undoBackupArray.count > undoArray.count {
            undoBackupArray.removeLast()
        }
        undoArray.append(object)
        undoBackupArray.append(object)
        
        if undoBackupArray.count > 120 {
            undoArray.removeFirst()
            undoBackupArray.removeFirst()
        }
        
        checkIfReachedToEnd()
        
        if (delegate != nil) {
            delegate.imageEraserUndoManager_RedoneWithPaths(dics: undoArray)
        }
    }
    
    func undo() {
        
        if undoArray.count > 0 {
            undoArray.removeLast()
            
            if (delegate != nil) {
                delegate.imageEraserUndoManager_UndoneWithPaths(dics: undoArray)
            }
        }
        checkIfReachedToEnd()
    }
    
    func redo() {
        
        if undoArray.count < undoBackupArray.count {
            
            let path = undoBackupArray[undoArray.count]
            undoArray.append(path)
            
            if (delegate != nil) {
                delegate.imageEraserUndoManager_RedoneWithPaths(dics: undoArray)
            }
        }
        checkIfReachedToEnd()
    }
    
    
    func checkIfReachedToEnd() {
        
        if undoArray.count > 0 {
            if (delegate != nil) {
                delegate.imageEraserUndoManager_ReachedToStart(isReached: false)
            }
        } else {
            if (delegate != nil) {
                delegate.imageEraserUndoManager_ReachedToStart(isReached: true)
            }
        }
        
        if undoArray.count < undoBackupArray.count {
            if (delegate != nil) {
                delegate.imageEraserUndoManager_ReachedToEnd(isReached: false)
            }
        } else {
            if (delegate != nil) {
                delegate.imageEraserUndoManager_ReachedToEnd(isReached: true)
            }
        }
    }
    
}
