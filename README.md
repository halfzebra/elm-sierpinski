## Sierpinski triangle in Elm

An implementation of Sierpinski triangle in Elm,
currently has only recursive implementation of the algorithm and
relies on `elm-lang/graphics`.

![Sierpinski Triangle in Elm](/../master/example/screenshot.png?raw=true)

The project includes simple demo project.

### Building the example

Does not require Elm Platform to be installed globally.

Run the following commands in your terminal:

```bash
$ cd ./example
$ npm i
$ npm run build       # dev build
$ npm run build:prod  # minified prod build
```

Project also includes the configuration for Webpack with HMR
run the following command to start development server:

```bash
$ npm run start
```
