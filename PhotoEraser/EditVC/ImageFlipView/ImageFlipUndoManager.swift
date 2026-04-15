//
//  ImageFlipUndoManager.swift
//  ImageFlip
//
//  Created by Rashed Nizam on 26/9/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageFlipUndoManagerDelegate {
    func imageFlipUndoManager_ReachedToStart(isReached: Bool)
    func imageFlipUndoManager_ReachedToEnd(isReached: Bool)
    
    func imageFlipUndoManager_UndoneWithFlag(isHFlipped: Bool)
    func imageFlipUndoManager_RedoneWithFlag(isHFlipped: Bool)
}

class ImageFlipUndoManager: NSObject {

    var delegate: ImageFlipUndoManagerDelegate!
    
    var undoArray = [Bool]()
    var undoBackupArray = [Bool]()
    
    func reset() {
        undoArray.removeAll()
        undoBackupArray.removeAll()
        if (delegate != nil) {
            delegate.imageFlipUndoManager_ReachedToStart(isReached: true)
            delegate.imageFlipUndoManager_ReachedToEnd(isReached: true)
        }
    }
    
    
    func addObject(isHFlipped: Bool) {
        while undoBackupArray.count > undoArray.count {
            undoBackupArray.removeLast()
        }
        undoArray.append(isHFlipped)
        undoBackupArray.append(isHFlipped)
        
        if undoBackupArray.count > 120 {
            undoArray.removeFirst()
            undoBackupArray.removeFirst()
        }
        
        checkIfReachedToEnd()
        
        if (delegate != nil) {
//            delegate.imageFlipUndoManager_RedoneWithPaths(point: undoArray)
        }
    }
    
    func undo() {
        
        if undoArray.count > 0 {
            let isHFlipped:Bool = undoArray[undoArray.count-1];
            undoArray.removeLast()
            
            if (delegate != nil) {
                delegate.imageFlipUndoManager_UndoneWithFlag(isHFlipped: isHFlipped)
            }
        }
        checkIfReachedToEnd()
    }
    
    func redo() {
        
        if undoArray.count < undoBackupArray.count {
            
            let point = undoBackupArray[undoArray.count]
            undoArray.append(point)
            
            if (delegate != nil) {
                let isHFlipped = undoArray[undoArray.count-1];
                delegate.imageFlipUndoManager_RedoneWithFlag(isHFlipped: isHFlipped)
            }
        }
        checkIfReachedToEnd()
    }
    
    
    func checkIfReachedToEnd() {
        
        if undoArray.count > 0 {
            if (delegate != nil) {
                delegate.imageFlipUndoManager_ReachedToStart(isReached: false)
            }
        } else {
            if (delegate != nil) {
                delegate.imageFlipUndoManager_ReachedToStart(isReached: true)
            }
        }
        
        if undoArray.count < undoBackupArray.count {
            if (delegate != nil) {
                delegate.imageFlipUndoManager_ReachedToEnd(isReached: false)
            }
        } else {
            if (delegate != nil) {
                delegate.imageFlipUndoManager_ReachedToEnd(isReached: true)
            }
        }
    }
    
}
