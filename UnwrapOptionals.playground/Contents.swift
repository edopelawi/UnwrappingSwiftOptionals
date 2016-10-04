/*:
# Unwrapping Swift Optionals

Let's assume we got a function that need a `String` input and an optional parameter:
*/

func createGreetings(sailorName: String) -> String {
	return "👮 Ahoy, \(sailorName)! Welcome to S.S. Salty Sailor, arrr!"
}

var name: String?

/*:
There are several possible ways to pass it to our function, let's run through them one by one:
*/

/*:
## 1. Force-unwrap (`!`)

Ah, the ol' forceful way. Adding bang / exclamation (!) mark after the variable is a sure way to keep the compiler from whining:
*/

name = "Ol' Man Jenkins"
print(createGreetings(sailorName: name!))
/*:
Still, problem will arise when the variable is `nil`. Uncommenting the `createGreetings()` call below will cause an error, since it's a `nil`.
*/

name = nil
//print(createGreetings(sailorName: name!))

/*:
Because of this, we need to ensure that the variable is not `nil` before passing it.
*/

if name != nil {
	print(createGreetings(sailorName: name!))
}

/*:
Just as its name, the code above looks twice as forceful as before. Thankfully, Swift provide a better way to do this.

## 2: `if let` unwrap

An `if let` statement is like the `if` statement above, but less bangs 😉 we pass the non-`nil` value to a new variable, and execute the code inside the `if let` statement:
*/

name = "Donald Duck"

if let validName = name {
	print(createGreetings(sailorName: validName))
}

/*:
Since it only passes non-`nil` values, it won't execute the code inside the statement if the variable is a `nil`. The code in `if let` statement below won't be executed:
*/

name = nil

if let anotherName = name {
	print(createGreetings(sailorName: anotherName))
}

/*:
And, since naming things is the [second hardest thing in Computer Science](http://martinfowler.com/bliki/TwoHardThings.html), we could reuse the variable name for the `if let` statement. The compiler will use the unwrapped version for the code inside the statement.
*/

name = "Daffy Duck"

if let name = name {
	print(createGreetings(sailorName: name))
}

/*:
So, we got our hands on `if let`. While it's convenient, we could end up big or nested `if let` statement for complicated logic:
*/
if let name = name {
	
	let uppercasedName = name.uppercased()
	let lowercasedName = name.lowercased()
	
	// And whole other code here... just imagine it yourself 😁
	
	let newName = "Sgt. " + name
	
	print(createGreetings(sailorName: newName))
	
}


/*:

Assume the `if let` bracket above got several dozen lines of code - it would be cumbersome, no? It would be even worse if there's another `if` bracket inside it. Of course, we could use `return` early method, but we'll be forced to force-unwrap:
*/


func sampleEarlyReturnFunction(name: String?) {
	
	if name == nil {
		return
	}
	
	let anotherName = name!
	print(createGreetings(sailorName: anotherName))
}

sampleEarlyReturnFunction(name: name)

// Add another code here that uses `anotherName`...

/*:
Thankfully, Swift 2.0 provides a solution that allows us to return early cleanly:

## 3: `guard let` unwrap

`guard` syntax forces a code block to return early when its condition is not met. It also works with `let` for unwrapping optionals:
*/

func guardLetEarlyReturnFunction(name: String?) {
	
	guard let validName = name else {
		print("👺 \(#function): Invalid name provided!")
		return
	}
	
	print(createGreetings(sailorName: validName))
	
	// Add whole other code here :)
}

guardLetEarlyReturnFunction(name: nil)

guardLetEarlyReturnFunction(name: name)

/*:
Neat, right? With `guard`, we could handle the outlier cases on the top of the code block, and proceed with the normal case below it. Still, there are times that we only need `if let` or `guard let` only to return a value, such as below:
*/

func getValidString(string: String?) -> String {
	
	if let validString = string {
		return validString
	} else {
		return ""
	}
}

func anotherGetValidString(string: String?) -> String {
	
	guard let validString = string else {
		return ""
	}
	
	return validString
}

/*:
For this specific use case, Swift provides a simple shortcut:

## 4: `nil`-coalescing operator (`??`)

Based on the [documentation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID72), nil-coalescing operator (`??`) unwraps an optional if it isn't nil, and returns the other value otherwise. Simply put, it's a shortcut of `a != nil ? a! : b`.

This allows us to implement the code above with less code:
*/

func nilCoalescingGetValidString(string: String?) -> String {
	return string ?? ""
}

print(nilCoalescingGetValidString(string: nil))
print(nilCoalescingGetValidString(string: name))

let validName = nilCoalescingGetValidString(string: name)

print(createGreetings(sailorName: validName))

/*:

Besides the common operators above, there's another way to unwrap optionals - which is based by the implentation of the optionals itself.

## 5: `switch` statement

Why `switch` statement, you say? Long story short, I found [Benedict Terhecte's blog post](https://appventure.me/2015/10/17/advanced-practical-enum-examples/) about advanced enum usage a few months ago. There's a simplified implementation of Swift's optional there, that turned out to be an (somewhat like) enum with associated values:
*/

// Simplified implementation of Swift's Optional
enum MyOptional<T> {
	case Some(T)
	case None
}

/*:
Knowing this, we could use `switch`'s pattern matching to unwrap its values:
*/

func printSailorName(sailorName: String?) {
	
	switch sailorName {
	case .some(let validName):
		print(createGreetings(sailorName: validName))
	case .none:
		print("👺 The sailor name input is invalid!")
	}
}

printSailorName(sailorName: nil)
printSailorName(sailorName: name)

/*:
This is beneficial if we got two optionals and different conditions according to their values (or absence of it). On my latest project, I created a view model to cater date selection in a calendar. This is the *super* simplified version:
*/

import Foundation

class CalendarViewModel {
	
	var selectedCheckInDate: NSDate?
	var selectedCheckOutDate: NSDate?
	
	func update(selectedDate date: NSDate) {
		
		switch (selectedCheckInDate, selectedCheckOutDate) {
		case (.none, .none):
			selectedCheckInDate = date
		case (.some(_), .none):
			selectedCheckOutDate = date
		case (.some(_), .some(_)):
			selectedCheckOutDate = nil
			selectedCheckInDate = date
		default:
			break
		}
	}
}

/*:

Though we could implement the `update(selectedDate:)` method above using "equal-`nil`" checking, but IMO, it's more self-describing with `switch` pattern matching.

## Bonus: `flatMap` for Arrays

There's a `flatMap` built-in method for Swift Array that can be used to filter-out `nil` values. Here's an example:
*/

let sailorNames: [String?] = [
	nil,
	"Daffy Duck",
	"Donald Duck",
	nil,
	"Darkwing Duck",
	"Howard The Duck",
]

let unwrappedSailorNames = sailorNames.flatMap({ $0 })

for sailorName in unwrappedSailorNames {
	print(createGreetings(sailorName: sailorName))
}

/*:
It will only work if we return `Optional` element on the `flatMap` block, though. Here's a sample to test it:
*/

let unwrapFlatMapCount = sailorNames.flatMap { name -> String? in
		return name
}.count

let otherOptionalFlatMapCount = sailorNames.flatMap { name -> Int? in
	return name?.hashValue
}.count

let otherNormalFlatMapCount = sailorNames.flatMap { name -> Int in
	return name?.hashValue ?? 0
}.count

print("Unwrap flatMap count: \(unwrapFlatMapCount)")
print("Other optional flatMap count: \(unwrapFlatMapCount)")
print("Other `normal` flatMap count: \(otherNormalFlatMapCount)")

/*:

CMIIW, but from what I know, flatMap is meant to take a nested value inside an array and put it to the surface level (hence the _flatten_), and map it as needed. At first, I only think this will be useful to flatten a nested array:
*/

let duckSailors = ["Daffy", "Donald", "Howard"]
let sealSailors = ["Manatee", "Moby"]

let otherSailors = [duckSailors, sealSailors]

let flattenedSailors = otherSailors
.flatMap { nameArray -> [String] in
	return nameArray
}
	
print("Flatten Sailor names: \(flattenedSailors)")

flattenedSailors.forEach { name in
	print(createGreetings(sailorName: name))
}

/*:
The `duckSailors` and `sealSailors` above were `Strings` that nested inside a container - which is an array. Returning the exact array in `otherSailors`' `flatMap` block will flatten out the values inside it.

If we revisit the simplified `Optional` implementation above, we could see that `Optional` is just another container - that may contain something (`.Some(T)`), or none (`.None`). That's why the `flatMap` operation filters out `nil`s - because those `Optional` contains nothing! 😉

I hope you find this `*.playground` file useful! See you later on future posts! 😄

_P.S: I'll try to post an updated version of this for Swift 3 soon! 😉_

*/


enum ConfirmationData {
	case FirstCase(percentage: Float, redeemTotal: Float)
	case SecondCase
}




