# CoffeeLint Rule - No Implicit Loop Return

`npm i nho-sh/coffeelint-no-implicit-loop-return --save-dev`

A CoffeeLint rule that detects functions that end with a loop.
Since coffeescript turns everything into an expression that returns a value,
it will transpile into javascript that will take the result of each loop iteration,
push it into an array, and return the array as the result.

If you find this 'implicit result construction' undesired, this rule
will help you.

## Examples

```coffee
func = ->
	for i in [0..10]
		noop()

func2 = ->
	while true
		noop()

func3 = ->
	until false
		noop()
```

becomes

```js
var func, func2, func3;

func = function() {
  var i, j, results;
  results = [];
  for (i = j = 0; j <= 10; i = ++j) {
    results.push(noop());
  }
  return results;
};

func2 = function() {
  var results;
  results = [];
  while (true) {
    results.push(noop());
  }
  return results;
};

func3 = function() {
  var results;
  results = [];
  while (!false) {
    results.push(noop());
  }
  return results;
};
```

## Wait, but I *want* to return the loop result

If you want to return the loop results, you can construct the array in coffeescript,
or wrap the loop with `return ( loop code )`

```coffee
return (for i in [0..10]
	noop()
)
```
