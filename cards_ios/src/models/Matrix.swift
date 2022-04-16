//
//  Matrix.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/16/22.
//

import Foundation

struct Matrix<T> {
    let rows, columns: Int
    var matrix: [T]
    
    init(rows: Int, columns: Int, defaultValue: T) {
        self.rows = rows
        self.columns = columns
        self.matrix = Array(repeating: defaultValue, count: rows * columns)
    }
    init(rows: Int, columns: Int, matrix: [T]) {
        self.rows = rows
        self.columns = columns
        self.matrix = matrix
    }
    
    func indexValid(row: Int, column: Int) -> Bool {
        return (row >= 0) && (row < rows) && (column >= 0) && (column < columns)
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexValid(row: row, column: column), "Index Out of Range")
            return matrix[(row * columns) + column]
        } set {
            assert(indexValid(row: row, column: column), "Index Out of Range")
            matrix[(row * columns) + column] = newValue
        }
    }
}
