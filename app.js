/*jshint esversion: 6 */
const express = require('express');
const path = require('path');
const app = express();

const bodyParser = require('body-parser');
/*app.use(bodyParser.urlencoded({ extended: false }));*/
app.use(bodyParser.json());

app.use(express.static('static'));

const spawn = require('child_process').spawn;
const results = {
	result1: 'img/BothParameters.png',
	result2: 'img/fixationViolin.png', 
	result3: 'img/PupilViolin.png'
}

app.get('/analysis/', (req, res, next) => {
	// using spawn instead of exec, prefer a stream over a buffer
  	// to avoid maxBuffer issue
  	let process = spawn('python', ['./plotsample.py']);
  	process.stdout.on('data', function (data) {
  		res.send({url: data.toString()});
  	});
});

app.get('/analysis/:id/', (req, res, next) => {
  	let id = req.params.id;
  	res.send({url: results[id]});
});

const http = require('http');
const PORT = 3000;

http.createServer(app).listen(PORT, function (err) {
    if (err) console.log(err);
    else console.log("HTTP server on http://localhost:%s", PORT);
});