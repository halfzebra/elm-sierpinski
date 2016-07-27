const webpack = require('webpack');
const { resolve } = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

const LIFECYCLE_EVENT = process.env.npm_lifecycle_event;
let env = { dev: true };

if (LIFECYCLE_EVENT === 'build:prod') {
  env = { prod: true };
}

const getPlugins = function getPlugins(env) {

  const plugins = [
    new CleanWebpackPlugin([ 'dist' ]),
    new HtmlWebpackPlugin({
      template: 'src/index.html',
      inject: 'body',
      filename: 'index.html'
    })
  ];

  return (env.prod) ?
    plugins.concat([
      new webpack.optimize.UglifyJsPlugin({
        minimize: !!env.prod,
        compressor: { warnings: false }
      })
    ]) :
    plugins
};

module.exports = {
  entry: './src/index.js',
  output: {
    path: resolve(__dirname, 'dist/'),
    filename: '[hash].js'
  },
  devServer: {
    hot: true
  },
  resolve: {
    modulesDirectories: [ 'node_modules' ],
    extensions: [ '', '.js', '.elm' ]
  },
  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.elm$/,
        exclude: [ /elm-stuff/, /node_modules/ ],
        loader: LIFECYCLE_EVENT === 'start' ?
          'elm-hot!elm-webpack?pathToMake=node_modules/.bin/elm-make&verbose=true&warn=true' :
          'elm-webpack?pathToMake=node_modules/.bin/elm-make'
      }
    ]
  },
  plugins: getPlugins(env)
};
