# [biologica-ui](https://github.com/concord-consortium/biologica-ui)

These models originally evolved from the Biologica, [ITSI](http://concord.org/projects/itsi), and
[Geniquest](http://concord.org/projects/geniquest) projects created by the [Concord Consortium](http://www.concord.org/)

## Running Locally

This project is built using Brunch.io, which compiles the CoffeeScript,
stylesheets, and other assets.

### Dependencies

* [Node](http://nodejs.org/) [Download an installer](http://nodejs.org/download/) or run `brew install node`
* [Bower](http://bower.io/) Run `npm install -g bower`

### Setup Brunch and Project Libraries

You'll need to install the plugins required for the brunch project, as well
as libraries the project depends on. Run these commands:

```
  npm install
  bower install
```

### Starting the Server

Run this command:

```
  npm start
```

Now open http://localhost:3333 in your browser. Whenever you make a change to a file the
browser will be automatically refreshed. Thanks
[auto-reload-brunch](https://github.com/brunch/auto-reload-brunch).

Your files will automatically be built into the /public directory
whenever they change.

You can also just run `brunch build` to simply build the files into /public without starting 
the server.

### Running the tests

Run this command:

```
  npm test
```

A new Chrome window will open, and the results of the tests will be shown in your console.

If you have the server running (`npm start`) then any time you update a file the tests will
be re-run.

#### Running the tests with PhantomJS

* Install the latest version of Node (>= 0.10.11). You can use [Node Version Manager](https://github.com/creationix/nvm).
* Edit the file test/karma.conf.js to change `browsers: ['Chrome']` to `browsers: ['PhantomJS']`
* Run the tests with `npm test`

### Running the model integration tests

Run this command:

```
  ./test-models.sh
```

A new Chrome window will open, and the results of the tests will be shown in your console.

The model test files can be found in /test/models/


## Libraries and Frameworks Used

* [CoffeeScript](http://coffeescript.org/) - Making JavaScript suck less.
* [Brunch](http://brunch.io) - Asset Compilation
* [Node](http://nodejs.org/) - For Brunch
* [Stylus](http://learnboost.github.com/stylus/) - CSS Templating

## License

biologica-ui is Copyright 2015 (c) by the Concord Consortium and is distributed under
the [MIT](http://www.opensource.org/licenses/MIT).
