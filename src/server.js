const express = require('express');
const utils = require('./utils');
const fs = require('fs')
const path = './public/index.html'

const exp = express();

if (fs.existsSync(path)) {
    exp.use(express.static('public'));
} else {
    exp.get('/', (req, res) => {
        console.log('got request');
        res.send(utils.content);
    });
}

module.exports = exp;