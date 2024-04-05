import CloakedStringMacro
import Foundation

let safeApiKey = #cloaked("secret")
print(safeApiKey)

let s = String(data: Data([116, 111, 112, 45, 115, 101, 99, 114, 101, 116, 45, 97, 112, 105, 45, 107, 101, 121]), encoding: .utf8)
print(safeApiKey)
