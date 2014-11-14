FooBars
=======

Small and fast coffeescript template library.
Works as express middleware.

To parse:

> FooBars = require('FooBars').parse
> FooBars('PATH_TO_FILE.html',{myData:'Goes Here', can:function(){'also be a function'}},optionalCallback)

FooBars will run callback with 2 paramaters. Error and HTML.
If no callback is supplies, FooBars will return data in a Synchronous fassion.


Template Syntax:
==


###Sample data to be passed

```javascript
{
  a:function(){return 'a'},
  b:function(){return 'b'},
  friends:['Jonnie', 'Matt']
}
```

###If

```html
<if 'a' == a() || function(){ return 'a' }>
  <h1>Turns out 'a' is equal to 'a'</h1>
</if>
```

```html
<h1>Turns out 'a' is qual to 'a'</h1>
```


###Each

```html
<each of='this.friends'>
  <h1>I like {{name}}, he is my friend.</h1>
</each>
```

```html
<h1>I like Jonnie, he is my friend.</h1>
<h1>I like Matt, he is my friend.</h1>
```

###Templates

```html
<template name='home'>
  <h1>Template Code</h1>
</template>


<show name='home'></show> <!-- Load Template -->

```
