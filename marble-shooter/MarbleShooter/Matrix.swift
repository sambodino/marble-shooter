//
//  Matrix.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/9/16.
//  Copyright © 2016 Apress. All rights reserved.
//

struct Matrix<T> {
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(rows: Int, columns: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(row: Int, column: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }

}

