/*:
# Unwrapping Swift Optionals

Let's assume we got a function that need a `String` input and an optional parameter:
*/

func createGreetings(sailorName sailorName: String) -> String {
	return "👮 Ahoy, \(sailorName)! Welcome to S.S. Salty Sailor, arrr!"
}

var name: String?

/*:
Now, how will we pass it to our function?
*/

/*:
## 1. Force-unwrap (!)

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
And, since naming things is the [second hardest thing in Computer Science](http://martinfowler.com/bliki/TwoHardThings.html) 😉, we could reuse the variable name for the `if let` statement. The compiler will use the unwrapped version for the code inside the statement.
*/

name = "Daffy Duck"

if let name = name {
	print(createGreetings(sailorName: name))
}

/*:
So, we got our hands on `if let`. While it's convenient, we could end up big or nested `if let` statement for complicated logic:
*/
if let name = name {
	
	let uppercasedName = name.uppercaseString
	let lowercasedName = name.lowercaseString
	
	// And whole other code here... just imagine it yourself 😁
	
	let newName = "Sgt. " + name
	
	print(createGreetings(sailorName: newName))
	
}


/*:

Assume the `if let` bracket above got several dozen lines of code - it would be cumbersome, no? It would be even worse if there's another `if` bracket inside it. Of course, we could use `return` early method, but we'll be forced to force-unwrap:
*/


func sampleEarlyReturnFunction(sampleName: String?) {
	
	if sampleName == nil {
		return
	}
	
	let anotherName = sampleName!
	print(createGreetings(sailorName: anotherName))
}

sampleEarlyReturnFunction(name)

// Add another code here that uses `anotherName`...

/*:
Thankfully, Swift 2.0 provides a solution that allow us to return early cleanly:

## 3: `guard let` unwrap

`guard` syntax forces a code block to return early when its condition is not met. It also works with `let` for unwrapping optionals:
*/

func guardLetEarlyReturnFunction(sampleName: String?) {
	
	guard let validName = sampleName else {
		print("👺 \(#function): Invalid name provided!")
		return
	}
	
	print(createGreetings(sailorName: validName))
	
	// Add whole other code here :)
}

guardLetEarlyReturnFunction(nil)

guardLetEarlyReturnFunction(name)

/*:
Still, there are times that we only need `if let` or `guard let` only to return a value, such as below:
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

## 4: Nil-coalescing operator (`??`)

Based on the [documentation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID72), nil-coalescing operators (`??`) unwraps an optional if it isn't nil, and returns the other value otherwise. Simply put, it's a shortcut of `a != nil ? a! : b`.

This allows us to implement the code above with less code:
*/

func nilCoalescingGetValidString(string: String?) -> String {
	return string ?? ""
}


