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







