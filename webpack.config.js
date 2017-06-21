const path = require('path')
const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

const HTMLWebpackPluginConfig = new HtmlWebpackPlugin({
  template: path.join(__dirname, 'src', 'index.html'),
  filename: 'index.html',
  inject: 'body'
})

const ExtractTextPluginConfig = new ExtractTextPlugin({
  filename: 'index.css',
  disable: false,
  allChunks: true
})

const UglifyJsPluginConfig = new webpack.optimize.UglifyJsPlugin({
  beautify: false,
  mangle: {
    screw_ie8: true,
    keep_fnames: true
  },
  compress: {
    screw_ie8: true
  },
  comments: false
})

const LoaderOptionsPluginConfig = new webpack.LoaderOptionsPlugin({
  minimize: true,
  debug: false
})

let myPlugins = [HTMLWebpackPluginConfig]

let myLoaders = [
  {
    test: /\.elm$/,
    exclude: [/elm-stuff/, /node_modules/],
    loader: 'elm-webpack-loader?verbose=true&warn=true'
  },
  {
    test: /index\.js$/,
    exclude: [/node_modues/, /elm-stuff/],
    include: [/src/],
    loader: 'babel-loader'
  }
]

const CopyWebpackPluginConfig = new CopyWebpackPlugin([
  {
    from: 'src/blurbs',
    to: 'blurbs'
  },
  {
    from: 'src/images',
    ignore: ['.DS_Store', 'source/*.*'],
    to: 'images'
  },
  {
    from: 'src/melodies',
    to: 'melodies'
  },
  {
    from: 'src/server.js',
    to: 'server.js'
  }
])

if (process.env.NODE_ENV === 'production') {
  myLoaders = myLoaders.concat([
    {
      test: /\.(css|scss)$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: ['css-loader?importLoaders=1', 'postcss-loader']
      })
    }
  ])

  myPlugins = myPlugins.concat([
    ExtractTextPluginConfig,
    UglifyJsPluginConfig,
    LoaderOptionsPluginConfig,
    CopyWebpackPluginConfig
  ])
} else {
  myLoaders = myLoaders.concat([
    {
      test: /\.(css|scss)$/,
      use: [
        'style-loader',
        {
          loader: 'css-loader',
          options: {
            importLoaders: 1
          }
        },
        'postcss-loader'
      ]
    }
  ])
}

module.exports = {
  entry: {
    app: ['./src/index.js']
  },

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js'
  },

  plugins: myPlugins,

  module: {
    rules: myLoaders,
    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    contentBase: path.resolve(__dirname, 'src'),
    stats: { colors: true }
  }
}
