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
	result2: 'img/ViolinFixationsByOccurence.png', 
	result3: 'img/ViolinPupilSizeByOccurence.png'
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

/*app.use(function (req, res, next){
    console.log("HTTP request", req.method, req.url, req.body);
    next();
});

let Datastore = require('nedb');
let messages = new Datastore({filename: 'db/messages.db', autoload: true, timestampData: true});
let users = new Datastore({filename: 'db/users.db', autoload: true});

let multer = require('multer');
let upload = multer({dest: 'uploads/'});

var Message = (function(){
    return function item(message){
        this.content = message.content;
        this.username = message.username;
        this.upvote = 0;
        this.downvote = 0;
    };
}());

// Create

app.post('/api/users/', upload.single('picture'), function (req, res, next) {
	// try find user
	users.findOne({_id: req.body.username}, (error, data) => {
		if(error) return res.status(500).end(error.message);
		// If found
		else if(data) return res.status(409).end("Username:" + req.body.username + " already exists");
		else {
			// If not found, insert new user
			users.insert({_id: req.body.username, picture: req.file}, (error, data) => {
				if(error) return res.status(500).end(error.message);
				else return res.redirect('/');
			});
		}
	});
});

app.post('/api/messages/', function (req, res, next) {
    let message = new Message(req.body);
    messages.insert(message, (error, data) => {
    	if(error) return res.status(500).end(error.message);
    	else return res.json(data);
    });
});

// Read

app.get('/api/messages/', function (req, res, next) {
	// read all, sort by createdAt and only pick first 5
	messages.find({}).sort({createdAt: -1}).limit(5).exec((error, data) => {
		if(error) return res.status(500).end(error.message);
		else return res.json(data.reverse());
	});
});

app.get('/api/users/', function (req, res, next) {
	users.find({}, {_id: 1}, (error, data) => {
		if(error) return res.status(500).end(error.message);
		else {
			// Get all usernames and arrange them into a list
			let ans = [];
			data.forEach((doc) => {
				ans.push(doc._id);
			});
			return res.json(ans);
		}
	});
});

app.get('/api/users/:username/profile/picture/', (req, res, next) => {
	users.findOne({_id: req.params.username}, (error, data) => {
		if(error) return res.status(500).end(error.message);
		// if not found the user
		else if (!data) return res.status(404).end('username ' + req.params.username + ' does not exists');
		else  {
			// If found user, return the picture
        	res.setHeader('Content-Type', data.picture.mimetype);
        	// Need to use absolute path
        	res.sendFile(path.join(__dirname, data.picture.path));
		}
	});
});

// Update

app.patch('/api/messages/:id/', function (req, res, next) {
	let callback = (error, num, doc) => {
		if(error) return res.status(500).end(error.message);
		else if (num !== 1) {
			// if cannot find the corresponding message
			return res.status(404).end("Message id:" + req.params.id + " does not exists");
		}
		else return res.json(doc);
	};

	if(req.body.action === "upvote") {
		// if upvote
		messages.update({_id: req.params.id}, {$inc: {upvote: 1}}, {returnUpdatedDocs: true}, callback);
	} else if (req.body.action === "downvote") {
		// if downvote
		messages.update({_id: req.params.id}, {$inc: {downvote: 1}}, {returnUpdatedDocs: true}, callback);
	} else {
		// otherwise
		return res.status(400).end("Invalid argument");
	}
});

// Delete

app.delete('/api/messages/:id/', function (req, res, next) {
	messages.findOne({_id: req.params.id}, (error, doc) => {
		if(error) return res.status(500).end(error.message);
		else if (doc){
			// If find the corresponding message, delete
			let ans = doc;
			messages.remove({_id: req.params.id}, {}, (error, num) => {
				if(error) return res.status(500).end(error.message);
				else return res.json(ans);
			});
		} else {
			// If cannot find the corresponding message
			return res.status(404).end("Message id:" + req.params.id + " does not exists");
		}
	});
});*/

const http = require('http');
const PORT = 3000;

http.createServer(app).listen(PORT, function (err) {
    if (err) console.log(err);
    else console.log("HTTP server on http://localhost:%s", PORT);
});