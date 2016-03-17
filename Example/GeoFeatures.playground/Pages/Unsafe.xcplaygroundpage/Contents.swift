
import Swift

var m1 = UnsafeMutablePointer<Int>.alloc(10)

m1.initializeFrom([0,1,2,3,4,5,6,7,8,9])
m1.memory
m1.destroy(1)
m1.memory
m1.successor().memory
m1.successor().successor().memory

for index in 0..<10 {
    print(m1[index])
}
print("-----")

var m2 = UnsafeMutablePointer<Int>.alloc(10)

m2.moveInitializeFrom(m1, count: 10)

var m = 2

while  m <  10 {
    (m2 + (m - 1)).moveAssignFrom((m2 + m), count: 1)
    m = m + 1;
}

//(m2 + (m - 1)).moveAssignFrom((m2 + m), count: 10 - m)

for index in 0..<10 {
    print("\(m1[index]), \(m2[index])")
}
print("-----")