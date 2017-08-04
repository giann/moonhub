/*jshint esversion: 6 */
"use strict";

const webpack = require('webpack');
const path = require('path');
const BabiliPlugin = require("babili-webpack-plugin");
const WebpackShellPlugin = require('webpack-shell-plugin');

module.exports = [
    {
        entry: './src/moonhub.js',
        output: {
            path: path.resolve(__dirname, 'dist'),
            filename: 'moonhub.min.js',
            library: 'moonhub'
        },
        plugins: [
            new WebpackShellPlugin({
                onBuildStart: ['echo Minifying lua...', './minify.zsh'],
                onBuildEnd: []
            }),
            new webpack.DefinePlugin({
                WEB: JSON.stringify(true),
            }),
            new BabiliPlugin()
        ],
        stats: {
            errorDetails: true
        }
    },
    {
        entry: './src/moonhub.js',
        output: {
            path: path.resolve(__dirname, 'dist'),
            filename: 'moonhub.js',
            library: 'moonhub'
        },
        plugins: [
            new webpack.DefinePlugin({
                WEB: JSON.stringify(true),
            })
        ],
        stats: {
            errorDetails: true
        }
    }
];
